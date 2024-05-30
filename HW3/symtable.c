/* 
 * symtable.c - symbol table & hash table management for Identifier
 * programmer - 윤경민
 * date - 2024.04.28.
 * 심볼 테이블과 해쉬 테이블 관련된 구조와 함수가 정의된 파일
 * 인식된 Identifier을 심볼 테이블과 해쉬테이블로 관리합니다.
 */

#include <stdio.h>
#include <stdlib.h>
#include "global.h"
#include "symtable.h"

// 인식된 identifier의 ST 내 index 값
int stindex;

// identifier의 시작 index
int nextid = 0;
// identifier의 끝 index
int nextfree = 0;

// test.dat의 줄 번호
int lineNum = 1;
// 감지된 에러 총 개수
int cErrors = 0;

//IsLetter() - input이 문자인지 아닌 지 확인
int IsLetter(char input) {
    //a~z, A~Z, _ 중 하나라면 1 리턴, 아니라면 0 리턴
    if ((input <= 'z' && input >= 'a') || (input <= 'Z' && input >= 'A') || (input == '_'))
        return 1;
    else return 0;
}

//IsDigit() - input이 숫자인지 아닌 지 확인
int IsDigit(char input) {
    //0~9 중 하나라면 1 리턴, 아니라면 0 리턴
    if (input >= '0' && input <= '9')
        return 1;
    else return 0;

}

//ComputHS function
//identifier의 hashcode를 연산하는 함수
//ST내 identifier의 시작 인덱스(nid)부터 끝 인덱스(nfree)까지 순회하며
//identifier의 각 글자의 아스키 코드 합에 mod 연산을 하여 hashcode 값을 구함
int ComputeHS(int nid, int nfree)
{
    HTpointer hp;
    //더한 값을 0으로 초기화
    int sum = 0;

    //순회하며 아스키 코드를 더해줌.
    for (int i = nid; i < nfree; i++) {
        sum += ST[i];
    }
    //더한 값을 HT 사이즈로 mod 연산을 진행함.
    int hscode = sum % HTsize;
    return hscode;
}


// LookupHS function
// HT에 identifier가 존재하는지 살펴보는 함수
// hashcode가 같아 충돌이 발생하는 경우, 같은 identifier인지 아니면 hashcode 값만 같은 identifier인지 파악
// HTpointer에 저장된 ST 인덱스 정보를 통해 ST에 저장된 각 글자를 비교
// for문 안에서 break하지 않았고, 마지막 포인터가 가리키는 글자가 종료 문자인 '\0'이라면
// 같은 identifier로 간주해 found 플래그를 1로 바꾸고 시작 인데스를 저장하고 종료
int LookupHS(int nid, int hscode)
{
    HTpointer now_ptr = HT[hscode];
    HTpointer idx_ptr = now_ptr;
    int found = 0;
    int i;

    while (idx_ptr != NULL) {
        for (i = nid; ST[i] != '\0'; i++) {
            if (ST[i] != ST[idx_ptr->index + i - nid]) {
                found = 0;
                break;
            }
            else {
                found = 1;
            }
        }
        if (found) {
            //글자 수까지 같은지 비교
            if (ST[idx_ptr->index + i - nid] == '\0') {
                found = 1;
                //이미 HT내에 존재하는 identifier이기에 해당 index 값을 stindex로 받아옴.
                stindex = idx_ptr->index;
                return found;
            }
        }
        idx_ptr = idx_ptr->next;
    }
    return found;

}

// ADDHT function
// HT에 새로운 identifier를 추가하는 함수
void ADDHT(int hscode)
{
    HTpointer ptr;
    ptr = (HTpointer)malloc(sizeof(ptr));

    ptr->index = nextid; // identifier의 인덱스
    ptr->info->is_const = tmp_is_const;
    ptr->info->type = tmp_type;
    ptr->info->is_param = tmp_is_param;
    ptr->info->type_detail = tmp_type_detail;
    ptr->info->var_type = tmp_var_type;
    tmp_is_param == 1 ? (ptr->info->func_name = recent_func_name) : NULL ;
    ptr->info->line_number = lineNum;
    ptr->next = HT[hscode];

    //HT[hashcode]가 NULL이 아니라면
    if (HT[hscode] != NULL) {
        //chain의 가장 앞에 옴.
        ptr->next = HT[hscode];
        HT[hscode] = ptr;
    }
    else { //NULL이라면
        HT[hscode] = ptr;
        ptr->next = NULL;
    }
    InitTmpIdentInfo();

}

void PrintHT(){
    
}


// symboltable function
// 인식된 identifier을 symboltable로 관리하는 함수
void SymbolTable() {
    // 에러가 없는 상태로 초기화
    err = NoError;
    // ST 내 시작 index 초기화
    nextid = nextfree;

    // identifier의 길이가 12자 초과이면 TooLong 에러 출력
    if (yyleng > 12) {
        err = TooLong;
        //reporterror();
        return ;
    }
    // yytext를 길이만큼 순회하며 ST에 저장
    for (int i = 0; i < yyleng; i++) {
        // STsize를 넘어가면 OverFlow 에러 출력
        if (nextfree == STsize) {
            err = OverFlow;
            //reporterror();
        }
        //ST 내에 저장
        ST[nextfree++] = yytext[i];
    }
    // identifier를 모두 저장하면 ST내에서 구분을 위해 '\0' 값을 첨부
    ST[nextfree++] = '\0';

    // ST에 identifier을 저장하는 동안 에러가 없었다면
    // HT 내에 추가해도 괜찮음
    if (err == NoError) {
        // hscode 값 계산
        int hscode = ComputeHS(nextid, nextfree);
        // 기존 HT에 존재하는 identifier인지 확인
        int found = LookupHS(nextid, hscode);

        if (!found) { // HT내에 존재하지 않는 identifier라면
            // HT에 추가
            ADDHT(hscode);
            // 새로 등록한 identifier의 ST 내 index 값 저장
            stindex = nextid;
        }
        else { // 기존에 HT내에 존재하는 identifier라면
            // ST 내에 인식한 identfier를 덮어쓰기하도록 끝 인덱스 값 조정
            nextfree = nextid;
        }
        printf("%d\t\tTIDENT\t\t   %d\t\t%s\n", lineNum, stindex, yytext);
        return ;
    }
    else { // 에러가 존재한다면
        // ST 내에 인식한 identifier을 덮어쓰기하도록 끝 인덱스 값 조정
        nextfree = nextid;
        // 에러 출력 함수 호출
        //reporterror();
        return ;
    }
}