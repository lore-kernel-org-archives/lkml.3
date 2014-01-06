Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbaAFNFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 08:05:39 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:40819 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaAFNFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:05:34 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org
Cc: minchan@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 1/3] Documentation: HOWTO: update LXR web link in ko_KR
Date: Mon,  6 Jan 2014 22:05:09 +0900
Message-Id: <1389013511-13740-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

English version HOWTO updated the link but Korean version didn't. Update
it now.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 Documentation/ko_KR/HOWTO | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ko_KR/HOWTO b/Documentation/ko_KR/HOWTO
index d61a45a..020b2b4 100644
--- a/Documentation/ko_KR/HOWTO
+++ b/Documentation/ko_KR/HOWTO
@@ -213,7 +213,7 @@ Documentation/DocBook/ 디렉토리 내에서 만들어지며 PDF, Postscript, H
 것은 Linux Cross-Reference project이며 그것은 자기 참조 방식이며
 소스코드를 인덱스된 웹 페이지들의 형태로 보여준다. 최신의 멋진 커널
 코드 저장소는 다음을 통하여 참조할 수 있다.
-      http://users.sosdg.org/~qiyong/lxr/
+      http://lxr.linux.no/+trees
 
 
 개발 프로세스
-- 
1.8.1.2

