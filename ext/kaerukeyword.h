//************************************
//          kaerukeyword.h
//
//         KaeruKeyword クラス
//
//       trie木を構築、検索を行う
//
//          Tsukasa OISHI
//
//           2009/10/02
//************************************


// bool型
#define true    1
#define false   0
typedef char bool;

#define CR '\r'
#define LF '\n'
#define TAB '\t'
#define SPACE ' '

// 一バイト文字をあらわす構造体
typedef struct _node {
    char    moji;               // 文字
    bool    end_flag;           // 単語の終端か

    struct _node    *child_head;// 子リストの先頭
    struct _node    *next;      // 兄弟ノードへのポインタ
} *node;


// node構造体の初期化
node initialize_node(char);


// 子の追加
void add_child(node, node);


// 指定された文字を持つ子を返す
node search_child(node, char);

// 指定された文字を持つ子を返す。
// 子が存在しないときはあらたに子を作成してそれを返す。
node search_child_or_create(node, char);


// 渡されたノード以下の全ノードのメモリを解放
void destroy_node(node);


//-----------------------------------------------------------
// Ruby メソッド
// ----------------------------------------------------------

// newメソッド
static VALUE t_new(int, VALUE *, VALUE);


// addメソッド
static VALUE t_add(VALUE, VALUE);


// searchメソッド
static VALUE t_search(VALUE, VALUE);


// クラス定義
void Init_kaerukeyword();

