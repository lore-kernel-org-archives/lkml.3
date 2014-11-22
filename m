Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaKVHoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 02:44:10 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39460 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaKVHoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 02:44:09 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] drivers:staging:skein:skein_generic.c: Fixed a whitespace error
Date: Sat, 22 Nov 2014 13:11:59 +0530
Message-Id: <1416642119-5827-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

     This patch fixes the checkpatch.pl error:

     ERROR: trailing whitespace

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/skein/skein_generic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
index 7096d5a..268e4de 100644
--- a/drivers/staging/skein/skein_generic.c
+++ b/drivers/staging/skein/skein_generic.c
@@ -188,7 +188,6 @@ static int __init skein_generic_init(void)
 		goto unreg256;
 	if (crypto_register_shash(&alg1024))
 		goto unreg512;
-
 	return 0;
 unreg512:
 	crypto_unregister_shash(&alg512);
-- 
1.9.1

