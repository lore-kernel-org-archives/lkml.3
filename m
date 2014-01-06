Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbaAFNFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 08:05:51 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:41947 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaAFNFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:05:47 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org
Cc: minchan@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 2/3] Documentation: HOWTO: update stable address in ko_KR
Date: Mon,  6 Jan 2014 22:05:10 +0900
Message-Id: <1389013511-13740-2-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389013511-13740-1-git-send-email-sj38.park@gmail.com>
References: <1389013511-13740-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

English version HOWTO updated the address but Korean version didn't.
Update it now.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 Documentation/ko_KR/HOWTO | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ko_KR/HOWTO b/Documentation/ko_KR/HOWTO
index 020b2b4..07ec392 100644
--- a/Documentation/ko_KR/HOWTO
+++ b/Documentation/ko_KR/HOWTO
@@ -275,7 +275,7 @@ Andrew Morton의 글이 있다.
 어떤 2.6.x.y 커널도 사용할 수 없다면 그때는 가장 높은 숫자의 2.6.x
 커널이 현재의 안정 커널이다.
 
-2.6.x.y는 "stable" 팀<stable@kernel.org>에 의해 관리되며 거의 매번 격주로
+2.6.x.y는 "stable" 팀<stable@vger.kernel.org>에 의해 관리되며 거의 매번 격주로
 배포된다.
 
 커널 트리 문서들 내에 Documentation/stable_kernel_rules.txt 파일은 어떤
-- 
1.8.1.2

