extern int lineNum;
extern int cErrors;

//0: const 아님, 1: const 임
extern int tmp_is_const;
//0: null, 1: 변수, 2: 함수
extern int tmp_type;
//0: null, 1: 함수 파라미터
extern int tmp_is_param;
//0: null, 1: int, 2: float, 3: void
extern int tmp_type_detail;
//0: null, 1: scalar, 2: array
extern int tmp_var_type;
//extern int tmp_array_size; //배열인 경우, 배열 크기
extern char *recent_func_name;

extern void InitTmpIdentInfo(){
    tmp_is_const = 0;
    tmp_type = 0;
    tmp_is_param = 0;
    tmp_type_detail = 0;
    tmp_var_type = 0;
}

enum errorTypes { NoError, WrongStatement, WrongFuncDef, NoSemi,NoBrace,
NoBracket,WrongChar, StartDigit, TooLong, OverFlow };
typedef enum errorTypes ERRORtypes;
ERRORtypes err;
