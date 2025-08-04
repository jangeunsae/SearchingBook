# SearchingBookApp

SearchingBookApp은 사용자가 책을 검색하고, 선택한 책을 상세히 확인하고, 장바구니에 담아 관리할 수 있는 iOS 앱입니다. KakaoBook API를 활용해 도서 정보를 불러오며, Core Data를 통해 검색 내역 및 장바구니 데이터를 로컬에 저장합니다.

---

## 주요 기능

- 🔍 **도서 검색 기능**  
  KakaoBook API를 활용하여 책 제목 또는 저자를 기준으로 실시간 검색

- 📖 **도서 상세 페이지**  
  책 이미지를 비롯한 상세 정보 확인 가능 (제목, 저자, 가격 등)

- 🛒 **장바구니 기능**  
  관심 도서를 장바구니에 담아 관리  
  Core Data를 이용해 앱 종료 후에도 데이터 유지

- 📚 **검색 기록 저장 및 표시**  
  최근 검색한 도서를 리스트로 보여주는 섹션 제공

---

## 🧱 기술 스택

- **UIKit**
- **Swift**
- **SnapKit** (레이아웃 제약 설정)
- **Core Data** (장바구니 및 검색 기록 저장)
- **URLSession + Codable** (Kakao API 통신)
- **MVC 아키텍처 기반 구성**

---

## 🗂️ 폴더 구조
SearchingBookApp/

├── CartViewController.swift
├── SearchViewController.swift
├── BookDetailViewController.swift
├── TabBarViewController.swift
├── AppDelegate.swift
├── SceneDelegate.swift
├── Info.plist
├── Assets.xcassets/
├── Base.lproj/
│   ├── LaunchScreen.storyboard
│   └── Main.storyboard
├── SearchingBookApp.xcdatamodeld/

## Kakao API 연동 방법
1.	https://developers.kakao.com 접속 → 앱 생성
2.	REST API 키 복사 후 SearchViewController.swift 내부에 적용
``` let apiKey = "KakaoAK <발급받은_키>" ```
