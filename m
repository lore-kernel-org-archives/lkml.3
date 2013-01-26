Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3AZKvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 05:51:06 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:45336 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3AZKvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 05:51:02 -0500
From: Ryo Munakata <ryomnktml@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        ryomnktml@gmail.com
Subject: [PATCH -next] Staging: zcache: remove unnecessary braces in zcache-main.c
Date: Sat, 26 Jan 2013 19:50:53 +0900
Message-Id: <1359197453-26178-1-git-send-email-ryomnktml@gmail.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a checkpatch.pl issue of
'braces {} are not necessary for single statement blocks'

Signed-off-by: Ryo Munakata <ryomnktml@gmail.com>
---
 drivers/staging/zcache/zcache-main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 6ab13e1..c1ac905 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1017,11 +1017,10 @@ static int zcache_frontswap_unuse(void)
 		unuse_ret = frontswap_unuse(type, offset,
 				newpage2 != NULL ? newpage2 : evictpage2,
 				ZCACHE_GFP_MASK);
-		if (unuse_ret != 0) {
+		if (unuse_ret != 0)
 			goto free_and_out;
-		} else if (evictpage2 != NULL) {
+		else if (evictpage2 != NULL)
 			zcache_unacct_page();
-		}
 	}
 	ret = 0;
 	goto out;
-- 
1.8.1.1

