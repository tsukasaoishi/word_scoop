//************************************
//          word_scoop.h
//
//          Tsukasa OISHI
//
//           2009/11/21
//************************************


#define CR '\r'
#define LF '\n'
#define TAB '\t'
#define SPACE ' '
#define NULL_CHAR '\0'

#define BEGIN_TAG '<'
#define END_TAG '>'

#define A_TAG "a"
#define SCRIPT_TAG "script"
#define PRE_TAG "pre"
#define IFRAME_TAG "iframe"
#define OBJECT_TAG "object"

#define EMPTY_STRING ""
#define LINK_URL_VARIABLE "@link_url"
#define DEAULT_LINK_URL "<a href='http://ja.wikipedia.org/wiki/%s'>%s</a>"

// node is 1 byte character
typedef struct _node {
    char    moji;               // character
    bool    end_flag;           // true if end of word

    struct _node    *child_head;// head of child list
    struct _node    *next;      // pointer of sibling node
} *node;
