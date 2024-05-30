// Identifier 정보 관련 구조체
typedef struct IdentifierInfo {
    //0: const 아님, 1: const 임
    int is_const;
    //0: null, 1: 변수, 2: 함수
    int type;
    //0: null, 1: int, 2: float
    int type_detail;
    //0: null, 1: 함수 파라미터
    int is_param;
    //0: null, 1: scalar, 2: array
    int var_type;
    int line_number; //줄 번호
    char *func_name; //파라미터 인 경우, 함수 이름 저장
    /*
    union {
        int array_size; //배열인 경우, 배열 크기
        
        //char **parameters; //함수인 경우, 파라미터도 출력할 것인지 결정
    } sub_detail;
    */
};

// HashTable 관련 구조체
typedef struct HTentry* HTpointer;
typedef struct IdentifierInfo* IdentInfo;

typedef struct HTentry {
    int index;
    HTpointer next;
    IdentInfo info;
} HTentry;

// SymbolTable 크기
#define STsize 1000
// HashTable 크기
#define HTsize 100

// HT 배열 선언
extern HTpointer HT[HTsize];
// ST 배열 선언
extern char ST[STsize];

extern char *yytext;
extern int yyleng;