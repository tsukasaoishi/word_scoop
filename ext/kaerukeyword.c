//************************************
//           kaerukeyword.c
//
//         KaeruKeyword クラス
//
//       trie木を構築、検索を行う
//
//          Tsukasa OISHI
//
//           2009/10/02
//************************************

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ruby.h>
#include "kaerukeyword.h"


// node構造体の初期化
node initialize_node(char moji)
{
    node work = (node)malloc(sizeof(struct _node));
    if (!work) {
        // 例外処理
        rb_raise(rb_eStandardError, "メモリが足りません");
    }

    work->moji = moji;
    work->end_flag = false;
    work->child_head = NULL;
    work->next = NULL;

    return work;
}

// 子の追加
void add_child(node parent, node child)
{
    if (parent->child_head) {
        child->next = parent->child_head;
        parent->child_head = child;
    } else {
        parent->child_head = child;
    }
}

// 指定された文字を持つ子を返す
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

// 指定された文字を持つ子を返す。
// 子が存在しないときはあらたに子を作成してそれを返す。
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

// 渡されたノード以下の全ノードのメモリを解放
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

//-----------------------------------------------------------
// Ruby メソッド
// ----------------------------------------------------------

// newメソッド
static VALUE t_new(int argc, VALUE *argv, VALUE klass)
{
    node root;
    VALUE obj, array, string;

    root = initialize_node('\0');

    obj = Data_Make_Struct(klass, struct _node, NULL, destroy_node, root);

    if (argc == 1) {
        array = argv[0];
        while((string = rb_ary_shift(argv[0])) != Qnil) {
            t_add(obj, string);
        }
    }

    return obj;
}

// addメソッド
static VALUE t_add(VALUE self, VALUE str)
{
    node root, now;
    char *keyword;
    int i, len;

    keyword = STR2CSTR(str);

    len = strlen(keyword);
    while(keyword[len - 1] == CR || keyword[len - 1] == LF ||
            keyword[len - 1] == TAB ||  keyword[len - 1] == SPACE) {
        len--;
    }

    Data_Get_Struct(self, struct _node, root);
    now = root;

    for(i = 0; i < len; i++) {
        now = search_child_or_create(now, keyword[i]);
    }

    now->end_flag = true;

    return str;
}

// searchメソッド
static VALUE t_search(VALUE self, VALUE str)
{
    node root, now, ret;
    char *text;
    int i, head_i, tail_i, total_len;
    VALUE array;

    array = rb_ary_new();
    text = STR2CSTR(str);

    Data_Get_Struct(self, struct _node, root);

    now = root;
    total_len = strlen(text);
    head_i = -1;
    tail_i = -1;

    for(i = 0; i < total_len; i++) {
        ret = search_child(now, text[i]);

        if (ret) {
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
                    rb_funcall(array, rb_intern("push"), 1, rb_str_new(&text[head_i], (tail_i - head_i + 1)));
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

    if (tail_i != -1) {
        rb_funcall(array, rb_intern("push"), 1, rb_str_new(&text[head_i], (tail_i - head_i + 1)));
    }

    return array;
}

// クラス定義
void Init_kaerukeyword() {
    VALUE cKaerukeyword;

    cKaerukeyword = rb_define_class("Kaerukeyword", rb_cObject);
    rb_define_singleton_method(cKaerukeyword, "new", t_new, -1);
    rb_define_method(cKaerukeyword, "add", t_add, 1);
    rb_define_method(cKaerukeyword, "search", t_search, 1);
    rb_define_alias(cKaerukeyword, "<<", "add");
}
