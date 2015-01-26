Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbbAZKYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:24:42 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:55504 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbbAZKYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:24:38 -0500
Date: Mon, 26 Jan 2015 12:24:33 +0200
From: Mariam Mohamed Fawzy <maryammohamed61@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, maryammohamed61@gmail.com,
        thomas.petazzoni@free-electrons.com, notro@tronnes.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] fix space required after that ','
Message-ID: <aa2201187c1e773b097042ff99d88b1bd6240469.1422267260.git.maryammohamed61@gmail.com>
References: <cover.1422267260.git.maryammohamed61@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1422267260.git.maryammohamed61@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following in checkpatch.pl error:
space required after that ','

Signed-off-by: Mariam Mohamed Fawzy <maryammohamed61@gmail.com>
---
 drivers/staging/fbtft/fb_bd663474.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fbtft/fb_bd663474.c b/drivers/staging/fbtft/fb_bd663474.c
index 1df19d7..17a2162 100644
--- a/drivers/staging/fbtft/fb_bd663474.c
+++ b/drivers/staging/fbtft/fb_bd663474.c
@@ -47,7 +47,7 @@ static int init_display(struct fbtft_par *par)
 	/* Initialization sequence from Lib_UTFT */
 
 	/* oscillator start */
-	write_reg(par, 0x000,0x0001);	/*oscillator 0: stop, 1: operation */
+	write_reg(par, 0x000, 0x0001);	/*oscillator 0: stop, 1: operation */
 	mdelay(10);
 
 	/* Power settings */
-- 
1.9.1

