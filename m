Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbbABDlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 22:41:04 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63505 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbbABDk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 22:40:58 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: akpm@linux-foundation.org, joe@perches.com,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] crypto: Remove unnecessary KERN_ERR in bfin_crc.c
Date: Fri,  2 Jan 2015 12:40:46 +0900
Message-Id: <1420170046-10269-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.2.1.62.g3f15098
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unnecessary KERN_ERR from bfin_crypto_crc_mod_init().

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/crypto/bfin_crc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index 9ae149b..33cf9eb 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -744,7 +744,7 @@ static int __init bfin_crypto_crc_mod_init(void)
 
 	ret = platform_driver_register(&bfin_crypto_crc_driver);
 	if (ret) {
-		pr_info(KERN_ERR "unable to register driver\n");
+		pr_err("unable to register driver\n");
 		return ret;
 	}
 
-- 
2.2.1.62.g3f15098

