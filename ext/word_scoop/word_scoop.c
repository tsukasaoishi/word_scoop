//************************************
//         word_scoop.c
//
//         Tsukasa OISHI
//
//           2009/11/21
//************************************

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ruby.h>
#include <ruby/encoding.h>
#include "word_scoop.h"


// initialize node
node initialize_node(char moji)
{
    node work = (node)malloc(sizeof(struct _node));
    if (!work) {
        // except
        rb_raise(rb_eStandardError, "memory is not enough");
    }

    work->moji = moji;
    work->end_flag = false;
    work->child_head = NULL;
    work->next = NULL;

    return work;
}

// add child node
void add_child(node parent, node child)
{
    if (parent->child_head) {
        child->next = parent->child_head;
    }
    parent->child_head = child;
}

// search node by use character
node search_child(node n, char moji)
{
    node child;
    
    child = n->child_head;
    while(child) {
        if (child->moji == moji) {
            break;
        }
        child = child->next;
    }

    return child;
}

// search node by use character.
// if nothing, create new node
node search_child_or_create(node n, char moji)
{
    node child;
    
    child = search_child(n, moji);
    if(!child) {
        child = initialize_node(moji);
        add_child(n, child);
    }

    return child;
}

// free memory all child and self
void destroy_node(node n)
{
    int i;
    node now, next;

    now = n->child_head;
    while(now) {
        next = now->next;
        destroy_node(now);
        now = next;
    }

    free(n);
}

// add encoding info
static VALUE add_encode(VALUE str, rb_encoding *enc)
{
  rb_enc_associate(str, enc);
  return str;
}

//-----------------------------------------------------------
// Ruby Methods
// ----------------------------------------------------------

/**
 * new
 **/
static VALUE t_new(int argc, VALUE *argv, VALUE klass)
{
    node root;
    VALUE obj, array, string;

    root = initialize_node(NULL_CHAR);

    obj = Data_Make_Struct(klass, struct _node, NULL, destroy_node, root);

    if (argc == 1) {
        array = argv[0];
        while((string = rb_ary_shift(argv[0])) != Qnil) {
            t_add(obj, string);
        }
    }

    return obj;
}

/**
 * add
 **/
static VALUE t_add(VALUE self, VALUE str)
{
    node root, now;
    char *keyword;
    int i, len;

    keyword = StringValuePtr(str);

    len = strlen(keyword);
    while(keyword[len - 1] == CR || keyword[len - 1] == LF ||
            keyword[len - 1] == TAB ||  keyword[len - 1] == SPACE) {
        len--;
    }

    if (len < 1) {
        return Qfalse;
    }

    Data_Get_Struct(self, struct _node, root);
    now = root;

    for(i = 0; i < len; i++) {
        now = search_child_or_create(now, keyword[i]);
    }

    now->end_flag = true;

    return str;
}

/**
 * search
 **/
static VALUE t_search(VALUE self, VALUE str)
{
    node root, now, ret;
    char *text;
    int i, head_i, tail_i, total_len;
    VALUE array;
    rb_encoding *enc;

    array = rb_ary_new();
    enc = rb_enc_get(str);
    text = StringValuePtr(str);

    Data_Get_Struct(self, struct _node, root);

    now = root;
    total_len = strlen(text);
    head_i = -1;
    tail_i = -1;

    for(i = 0; i <= total_len; i++) {
        ret = search_child(now, text[i]);

        if (ret && i != total_len) {
            if (head_i == -1) {
                head_i = i;
            }

            if (ret->end_flag) {
                tail_i = i;
            }
            now = ret;
        } else {
            if (head_i != -1) {
                if (tail_i != -1) {
                    rb_funcall(
                        array,
                        rb_intern("push"),
                        1,
                        add_encode(rb_str_new(&text[head_i], (tail_i - head_i + 1)), enc)
                    );
                    i = tail_i;
                    tail_i = -1;
                } else {
                    i = head_i;
                }
                head_i = -1;
            }
            now = root;
        }
    }

    return array;
}

/**
 * filter_html
 **/
static VALUE t_filter_html(VALUE self, VALUE str)
{
    node root, now, ret;
    bool in_tag;
    char *text, *inner_tag;
    int i, head_i, tail_i, copy_head_i, total_len;
    VALUE change_str, url_base, word;
    rb_encoding *enc;

    change_str = rb_str_new2(EMPTY_STRING);
    enc = rb_enc_get(str);
    text = StringValuePtr(str);

    Data_Get_Struct(self, struct _node, root);
    url_base = rb_iv_get(self, LINK_URL_VARIABLE);
    if (url_base == Qnil) {
        url_base = rb_str_new2(DEAULT_LINK_URL);
    }

    now = root;
    total_len = strlen(text);
    head_i = -1;
    tail_i = -1;
    copy_head_i = 0;
    in_tag = false;
    inner_tag = NULL;

    for(i = 0; i <= total_len; i++) {
        if (!in_tag && text[i] == BEGIN_TAG) {
            in_tag = true;
            if (strncasecmp(&text[i + 1], A_TAG, strlen(A_TAG)) == 0) {
                inner_tag = A_TAG;
            } else if (strncasecmp(&text[i + 1], SCRIPT_TAG, strlen(SCRIPT_TAG)) == 0) {
                inner_tag = SCRIPT_TAG;
            } else if (strncasecmp(&text[i + 1], PRE_TAG, strlen(PRE_TAG)) == 0) {
                inner_tag = PRE_TAG;
            } else if (strncasecmp(&text[i + 1], IFRAME_TAG, strlen(IFRAME_TAG)) == 0) {
                inner_tag = IFRAME_TAG;
            } else if (strncasecmp(&text[i + 1], OBJECT_TAG, strlen(OBJECT_TAG)) == 0) {
                inner_tag = OBJECT_TAG;
            }
            continue;
        }

        if (in_tag && !inner_tag && text[i] == END_TAG) {
            in_tag = false;
            continue;
        }

        if (inner_tag && text[i] == BEGIN_TAG) {
            if (strncasecmp(&text[i + 2], inner_tag, strlen(inner_tag)) == 0) {
                inner_tag = NULL;
                continue;
            }
        }

        if (in_tag) {
            continue;
        }

        ret = search_child(now, text[i]);

        if (ret && i != total_len) {
            if (head_i == -1) {
                head_i = i;
            }

            if (ret->end_flag) {
                tail_i = i;
            }
            now = ret;
        } else {
            if (head_i != -1) {
                if (tail_i != -1) {
                    if (copy_head_i < head_i) {
                        rb_funcall(
                            change_str, 
                            rb_intern("concat"),
                            1,
                            add_encode(rb_str_new(&text[copy_head_i], (head_i - copy_head_i)), enc)
                        );
                    }

                    word = rb_str_new(&text[head_i], (tail_i - head_i + 1));
                    rb_funcall(
                        change_str,
                        rb_intern("concat"),
                        1,
                        add_encode(rb_funcall(url_base, rb_intern("%"), 1, rb_assoc_new(word, word)), enc)
                    );
                    i = tail_i;
                    copy_head_i = tail_i + 1;
                    tail_i = -1;
                } else {
                    i = head_i;
                }
                head_i = -1;
            }
            now = root;
        }
    }

    if (copy_head_i == 0) {
        return str;
    } else {
        rb_funcall(
            change_str,
            rb_intern("concat"),
            1,
            add_encode(rb_str_new(&text[copy_head_i], (total_len - copy_head_i)), enc)
        );
        return change_str;
    }
}

/**
 * define class
 **/
void Init_word_scoop() {
    VALUE cWordScoop;

    cWordScoop = rb_define_class("WordScoop", rb_cObject);
    rb_define_singleton_method(cWordScoop, "new", t_new, -1);
    rb_define_method(cWordScoop, "add", t_add, 1);
    rb_define_method(cWordScoop, "search", t_search, 1);
    rb_define_method(cWordScoop, "filter_html", t_filter_html, 1);
    rb_define_alias(cWordScoop, "<<", "add");
}
