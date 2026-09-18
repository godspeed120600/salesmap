# 세일즈맵 (salesmap)

주소 목록을 카카오 지도 위에 띄우는 모바일 웹페이지. 핸드폰 브라우저로 열고 "홈 화면에 추가"하면 앱처럼 씁니다.

- 페이지: https://godspeed120600.github.io/salesmap/
- 데이터: 구글시트 (`index.html` 의 `CONFIG.SHEET_CSV_URL`)
- 마커 탭 → 카카오맵 앱으로 열기 / 길찾기 / 주소 복사
- `SRC_TYPE`(업태) 값별로 색상·필터 칩 자동 생성

## 데이터 갱신 (매달)
1. `신규창업시트\fetch_gy_raw.ps1 -ServiceKey ... -BgnYmd 20261001 -EndYmd 20261031` 실행 → `RAW_고양시_..._N건.xlsx` 생성
2. 엑셀에서 열어 필요 없는 행 삭제 (필요하면 맨 끝에 `메모` 컬럼 추가)
3. 데이터 행만 복사(헤더 제외) → 구글시트 맨 아래 빈 줄에 붙여넣기
4. 페이지 새로고침 — 재배포 불필요

구글시트 헤더는 RAW 파일 그대로 (`LCPMT_YMD, SRC_TYPE, BPLC_NM, 위도, 경도, SNTTN_BZSTAT_NM, BZSTAT_SE_NM, SALS_STTS_CD, SALS_STTS_NM, ROAD_NM_ADDR, LOTNO_ADDR` + 선택 `메모`).
페이지가 `BPLC_NM`→이름, `ROAD_NM_ADDR`→주소, `LCPMT_YMD`→인허가일자, `SRC_TYPE`→업태, `BZSTAT_SE_NM`→업종으로 읽습니다.
한글 헤더(`이름, 주소, 위도, 경도, 인허가일자, 업태, 업종, 메모`)도 그대로 인식하지만 한 시트에 두 형식을 섞지는 마세요.
`위도/경도`가 비어 있으면 `주소`로 자동 지오코딩합니다(결과는 브라우저에 캐시).

## 카카오 개발자 콘솔 설정 (필수)
1. 앱 설정 › **카카오맵 › 활성화 ON**
2. 앱 설정 › 앱 › **플랫폼 키** › JavaScript 키 선택 › **JavaScript SDK 도메인**에 `https://godspeed120600.github.io` 등록 (로컬 테스트용 `http://localhost:3000` 도 함께)

## 로컬 테스트
`serve.ps1` 실행 후 http://localhost:3000 (같은 와이파이의 핸드폰에서는 PC IP:3000)
