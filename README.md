# flutter_hwp_lib

A flutter hwp libary plugin project.

### 2023.08.30 begin
readme 작성에 필요한 메모만 기재하고 완료된후에는 정식으로 올리기전 README 작성

## Introduction
 - 한글파일에서 텍스트를 추출해야 되는 상황, pub.dev에 hwp에서 텍스트 추출 라이브러리 부재
 - 활용가능 라이브러리 서치 java로 작성되어 maven에서 jar로 지원하는 라이브러리와 
   swift로 작성된 package 라이브러리 발견

### android used library
https://github.com/neolord0/hwplib

### ios used library
https://github.com/sboh1214/Hwp-Swift

1. 프로젝트 생성후 각 라이브러리를 사용할 수 있는지 flutter 환경에서 테스트 실시
2. 각 소스를 분석하고 나서 android/ios에 공통적으로 사용할 수 있는 함수 도출
3. 이번 작업에서는 원 저자의 소스를 내가 수정할 일은 없으며 단지 라이브러리에서 지원하는
   함수명세에 따라서 flutter로 바인딩
4. pub.dev에 publish

#### android issue

jetified-hwplib-1.1.1.jar 
com.android.tools.r8.internal.k2: 
MethodHandle.invoke and MethodHandle.invokeExact are 
only supported starting with Android O (--min-api 26)

uses-sdk:minSdkVersion 19 cannot be smaller than version 21
declared in library [:integration_test] 
-> build.gradle, AndroidManifest.xml 관련 사항 적용
-> 빌드 성공

todo: 실제 기기에서 한글파일을 읽어와서 되는지 테스트 해볼것(예정)

#### ios issue

swift package 이용 레퍼런스
https://ktuusj.medium.com/writing-flutter-plugin-package-2-e6b480113a46
https://stackoverflow.com/questions/54329023/how-to-import-external-ios-framework-in-flutter-plugin
-> 모두 실패, ios에서는 podspec에서 external library import를 못하고 Podfile에서 가능.

todo: 플러그인에서 처리해야 하므로 원본 소스를 다시 패키징해야 되는지 좀더 검토해보기

### 2023.09.08 중간검토
* android 지원을 먼저 작업하고 pub.dev에 게시
* ios 지원은 나중에 좀더 swift에 익숙해진다음 작업하는 것으로 미룸.
