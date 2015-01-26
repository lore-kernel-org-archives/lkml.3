Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbbAZKX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:23:28 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39229 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964AbbAZKX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:23:26 -0500
Date: Mon, 26 Jan 2015 12:23:20 +0200
From: Mariam Mohamed Fawzy <maryammohamed61@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, maryammohamed61@gmail.com,
        thomas.petazzoni@free-electrons.com, notro@tronnes.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] fix space prohibited after that open parenthesis '('
Message-ID: <7f5618dc5a8c00564f167a834df261528d9e048a.1422267260.git.maryammohamed61@gmail.com>
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
space prohibited after that open parenthesis '('

Signed-off-by: Mariam Mohamed Fawzy <maryammohamed61@gmail.com>
---
 drivers/staging/fbtft/fb_bd663474.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/fbtft/fb_bd663474.c b/drivers/staging/fbtft/fb_bd663474.c
index 1e5ee2b..1df19d7 100644
--- a/drivers/staging/fbtft/fb_bd663474.c
+++ b/drivers/staging/fbtft/fb_bd663474.c
@@ -58,10 +58,10 @@ static int init_display(struct fbtft_par *par)
 	write_reg(par, 0x110, 0x009d);
 	write_reg(par, 0x111, 0x0022);
 	write_reg(par, 0x100, 0x0120);
-	mdelay( 20);
+	mdelay(20);
 
 	write_reg(par, 0x100, 0x3120);
-	mdelay( 80);
+	mdelay(80);
 	/* Display control */
 	write_reg(par, 0x001, 0x0100);
 	write_reg(par, 0x002, 0x0000);
@@ -114,7 +114,7 @@ static int init_display(struct fbtft_par *par)
 	write_reg(par, 0x201, 0x0000);
 	write_reg(par, 0x100, 0x7120);
 	write_reg(par, 0x007, 0x0103);
-	mdelay( 10);
+	mdelay(10);
 	write_reg(par, 0x007, 0x0113);
 
 	return 0;
-- 
1.9.1

