Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbbAZKVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:21:13 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:53141 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbAZKVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:21:09 -0500
Date: Mon, 26 Jan 2015 12:21:02 +0200
From: Mariam Mohamed Fawzy <maryammohamed61@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, maryammohamed61@gmail.com,
        thomas.petazzoni@free-electrons.com, notro@tronnes.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] fix space prohibited before that close parenthesis ')'
Message-ID: <cc794605dcdc29d196de09a7712ca0a55b876ecc.1422267260.git.maryammohamed61@gmail.com>
References: <cover.1422267260.git.maryammohamed61@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1422267260.git.maryammohamed61@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl error:
space prohibited before that close parenthesis ')'

Signed-off-by: Mariam Mohamed Fawzy <maryammohamed61@gmail.com>
---
 drivers/staging/fbtft/fb_bd663474.c | 98 ++++++++++++++++++-------------------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/fbtft/fb_bd663474.c b/drivers/staging/fbtft/fb_bd663474.c
index 7e00c60..1e5ee2b 100644
--- a/drivers/staging/fbtft/fb_bd663474.c
+++ b/drivers/staging/fbtft/fb_bd663474.c
@@ -51,45 +51,45 @@ static int init_display(struct fbtft_par *par)
 	mdelay(10);
 
 	/* Power settings */
-	write_reg(par, 0x100, 0x0000 ); /* power supply setup */
-	write_reg(par, 0x101, 0x0000 );
-	write_reg(par, 0x102, 0x3110 );
-	write_reg(par, 0x103, 0xe200 );
-	write_reg(par, 0x110, 0x009d );
-	write_reg(par, 0x111, 0x0022 );
-	write_reg(par, 0x100, 0x0120 );
-	mdelay( 20 );
-
-	write_reg(par, 0x100, 0x3120 );
-	mdelay( 80 );
+	write_reg(par, 0x100, 0x0000); /* power supply setup */
+	write_reg(par, 0x101, 0x0000);
+	write_reg(par, 0x102, 0x3110);
+	write_reg(par, 0x103, 0xe200);
+	write_reg(par, 0x110, 0x009d);
+	write_reg(par, 0x111, 0x0022);
+	write_reg(par, 0x100, 0x0120);
+	mdelay( 20);
+
+	write_reg(par, 0x100, 0x3120);
+	mdelay( 80);
 	/* Display control */
-	write_reg(par, 0x001, 0x0100 );
-	write_reg(par, 0x002, 0x0000 );
-	write_reg(par, 0x003, 0x1230 );
-	write_reg(par, 0x006, 0x0000 );
-	write_reg(par, 0x007, 0x0101 );
-	write_reg(par, 0x008, 0x0808 );
-	write_reg(par, 0x009, 0x0000 );
-	write_reg(par, 0x00b, 0x0000 );
-	write_reg(par, 0x00c, 0x0000 );
-	write_reg(par, 0x00d, 0x0018 );
+	write_reg(par, 0x001, 0x0100);
+	write_reg(par, 0x002, 0x0000);
+	write_reg(par, 0x003, 0x1230);
+	write_reg(par, 0x006, 0x0000);
+	write_reg(par, 0x007, 0x0101);
+	write_reg(par, 0x008, 0x0808);
+	write_reg(par, 0x009, 0x0000);
+	write_reg(par, 0x00b, 0x0000);
+	write_reg(par, 0x00c, 0x0000);
+	write_reg(par, 0x00d, 0x0018);
 	/* LTPS control settings */
-	write_reg(par, 0x012, 0x0000 );
-	write_reg(par, 0x013, 0x0000 );
-	write_reg(par, 0x018, 0x0000 );
-	write_reg(par, 0x019, 0x0000 );
-
-	write_reg(par, 0x203, 0x0000 );
-	write_reg(par, 0x204, 0x0000 );
-
-	write_reg(par, 0x210, 0x0000 );
-	write_reg(par, 0x211, 0x00ef );
-	write_reg(par, 0x212, 0x0000 );
-	write_reg(par, 0x213, 0x013f );
-	write_reg(par, 0x214, 0x0000 );
-	write_reg(par, 0x215, 0x0000 );
-	write_reg(par, 0x216, 0x0000 );
-	write_reg(par, 0x217, 0x0000 );
+	write_reg(par, 0x012, 0x0000);
+	write_reg(par, 0x013, 0x0000);
+	write_reg(par, 0x018, 0x0000);
+	write_reg(par, 0x019, 0x0000);
+
+	write_reg(par, 0x203, 0x0000);
+	write_reg(par, 0x204, 0x0000);
+
+	write_reg(par, 0x210, 0x0000);
+	write_reg(par, 0x211, 0x00ef);
+	write_reg(par, 0x212, 0x0000);
+	write_reg(par, 0x213, 0x013f);
+	write_reg(par, 0x214, 0x0000);
+	write_reg(par, 0x215, 0x0000);
+	write_reg(par, 0x216, 0x0000);
+	write_reg(par, 0x217, 0x0000);
 
 	/* Gray scale settings */
 	write_reg(par, 0x300, 0x5343);
@@ -104,18 +104,18 @@ static int init_display(struct fbtft_par *par)
 	write_reg(par, 0x309, 0x050a);
 
 	/* RAM access settings */
-	write_reg(par, 0x400, 0x4027 );
-	write_reg(par, 0x401, 0x0000 );
-	write_reg(par, 0x402, 0x0000 );  /* First screen drive position (1) */
-	write_reg(par, 0x403, 0x013f );  /* First screen drive position (2) */
-	write_reg(par, 0x404, 0x0000 );
-
-	write_reg(par, 0x200, 0x0000 );
-	write_reg(par, 0x201, 0x0000 );
-	write_reg(par, 0x100, 0x7120 );
-	write_reg(par, 0x007, 0x0103 );
-	mdelay( 10 );
-	write_reg(par, 0x007, 0x0113 );
+	write_reg(par, 0x400, 0x4027);
+	write_reg(par, 0x401, 0x0000);
+	write_reg(par, 0x402, 0x0000);  /* First screen drive position (1) */
+	write_reg(par, 0x403, 0x013f);  /* First screen drive position (2) */
+	write_reg(par, 0x404, 0x0000);
+
+	write_reg(par, 0x200, 0x0000);
+	write_reg(par, 0x201, 0x0000);
+	write_reg(par, 0x100, 0x7120);
+	write_reg(par, 0x007, 0x0103);
+	mdelay( 10);
+	write_reg(par, 0x007, 0x0113);
 
 	return 0;
 }
-- 
1.9.1

