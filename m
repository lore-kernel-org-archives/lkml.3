Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbbA2BQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:16:52 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47926 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbbA2BQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:16:50 -0500
Date: Wed, 28 Jan 2015 13:26:42 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: thomas.petazzoni@free-electrons.com, noralf@tronnes.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] staging: fbtft: fix trailing whitespace
Message-ID: <550505afe6f60b7a6cb77a55abfca6041e957567.1422443132.git.heba93aamer@gmail.com>
References: <cover.1422443132.git.heba93aamer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1422443132.git.heba93aamer@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl error:
trailing whitespace

Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
---
 drivers/staging/fbtft/fb_pcd8544.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/fbtft/fb_pcd8544.c b/drivers/staging/fbtft/fb_pcd8544.c
index 0510547..8b9ebfb 100644
--- a/drivers/staging/fbtft/fb_pcd8544.c
+++ b/drivers/staging/fbtft/fb_pcd8544.c
@@ -59,14 +59,14 @@ static int init_display(struct fbtft_par *par)
 						  */
 
 	/* H=1 Temperature control */
-	write_reg(par, 0x04 | (tc & 0x3)); /* 
+	write_reg(par, 0x04 | (tc & 0x3)); /*
 	                         2:1  1
 	                         1:x  TC1 - Temperature Coefficient: 0x10
 							 0:x  TC0
 						  */
 
 	/* H=1 Bias system */
-	write_reg(par, 0x10 | (bs & 0x7)); /* 
+	write_reg(par, 0x10 | (bs & 0x7)); /*
 	                         4:1  1
 	                         3:0  0
 							 2:x  BS2 - Bias System
@@ -82,7 +82,7 @@ static int init_display(struct fbtft_par *par)
 						  */
 
 	/* H=0 Display control */
-	write_reg(par, 0x08 | 4); /* 
+	write_reg(par, 0x08 | 4); /*
 	                         3:1  1
 	                         2:1  D  - DE: 10=normal mode
 							 1:0  0
-- 
1.7.9.5

