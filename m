Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab3HEHJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:09:55 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:65534 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3HEHJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:09:54 -0400
From: "Lee, Jae-Hong" <pyrasis@gmail.com>
To: minchan@kernel.org, rob@landley.net
Cc: linux-kernel@vger.kernel.org, "Lee, Jae-Hong" <pyrasis@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=20v3=203/3=5D=20Correct=20unfaithful=20translation=20on=20HOWTO=20in=20ko=5FKR?=
Date: Mon,  5 Aug 2013 16:09:43 +0900
Message-Id: <1375686583-2711-1-git-send-email-pyrasis@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lee, Jae-Hong" <pyrasis@gmail.com>

This patch corrects unfaithful Korean translation in Documentation/ko_KR/HOWTO.

Signed-off-by: Lee, Jae-Hong <pyrasis@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
---
 Documentation/ko_KR/HOWTO |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ko_KR/HOWTO b/Documentation/ko_KR/HOWTO
index 4aa79f9..6bf4832 100644
--- a/Documentation/ko_KR/HOWTO
+++ b/Documentation/ko_KR/HOWTO
@@ -455,7 +455,7 @@ bugme-janitor 메일링 리스트(bugzilla에 모든 변화들이 여기서 메
  - 의견
  - 변경을 위한 요구
  - 당위성을 위한 요구
- - 고요
+ - 침묵
 
 기억하라. 이것들은 여러분의 패치가 커널로 들어가기 위한 과정이다. 여러분의
 패치들은 비판과 다른 의견을 받을 수 있고 그것들을 기술적인 레벨로 평가하고
@@ -489,7 +489,7 @@ bugme-janitor 메일링 리스트(bugzilla에 모든 변화들이 여기서 메
 문제를 피하기 위한 목록이 있다.
   여러분들이 제안한 변경들에 관하여 말할 때 좋은 것들 :
     - "이것은 여러 문제들을 해결합니다."
-    - "이것은 2000 라인의 코드를 제거합니다."
+    - "이것은 2000 라인의 코드를 줄입니다."
     - "이것은 내가 말하려는 것에 관해 설명하는 패치입니다."
     - "나는 5개의 다른 아키텍쳐에서 그것을 테스트 했으므로..."
     - "여기에 일련의 작은 패치들이 있으므로..."
-- 
1.7.10.4

