Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799AbbA0Uqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:46:31 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33248 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066AbbA0Uq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:46:29 -0500
Date: Tue, 27 Jan 2015 22:46:25 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, notro@tronnes.org,
        thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] staging: fbtft: fix trailing whitespace
Message-ID: <f4b14b450b97d9dc59e02295b93fa6452aee6b99.1422296762.git.heba93aamer@gmail.com>
References: <cover.1422296762.git.heba93aamer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1422296762.git.heba93aamer@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl error:
fix trailing whitespace

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

