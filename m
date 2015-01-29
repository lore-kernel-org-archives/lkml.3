Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764174AbbA2DX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:23:29 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:48200 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbbA2DX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 22:23:26 -0500
From: Frederic Jacob <frederic.jacob.78@gmail.com>
To: thomas.petazzoni@free-electrons.com, noralf@tronnes.org,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Frederic Jacob <frederic.jacob.78@gmail.com>
Subject: [PATCH] Staging: fbtft: Fix Sparse warnings
Date: Wed, 28 Jan 2015 22:22:26 -0500
Message-Id: <1422501746-9242-1-git-send-email-frederic.jacob.78@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Fix Sparse warnings for undeclared symbols

Signed-off-by: Frederic Jacob <frederic.jacob.78@gmail.com>
---
 drivers/staging/fbtft/fb_hx8340bn.c  | 2 +-
 drivers/staging/fbtft/fbtft_device.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/fbtft/fb_hx8340bn.c b/drivers/staging/fbtft/fb_hx8340bn.c
index 3939502..26a987a 100644
--- a/drivers/staging/fbtft/fb_hx8340bn.c
+++ b/drivers/staging/fbtft/fb_hx8340bn.c
@@ -108,7 +108,7 @@ static int init_display(struct fbtft_par *par)
 	return 0;
 }
 
-void set_addr_win(struct fbtft_par *par, int xs, int ys, int xe, int ye)
+static void set_addr_win(struct fbtft_par *par, int xs, int ys, int xe, int ye)
 {
 	fbtft_par_dbg(DEBUG_SET_ADDR_WIN, par,
 		"%s(xs=%d, ys=%d, xe=%d, ye=%d)\n", __func__, xs, ys, xe, ye);
diff --git a/drivers/staging/fbtft/fbtft_device.c b/drivers/staging/fbtft/fbtft_device.c
index b9f4c30..157f79c 100644
--- a/drivers/staging/fbtft/fbtft_device.c
+++ b/drivers/staging/fbtft/fbtft_device.c
@@ -29,8 +29,8 @@
 
 #define MAX_GPIOS 32
 
-struct spi_device *spi_device;
-struct platform_device *p_device;
+static struct spi_device *spi_device;
+static struct platform_device *p_device;
 
 static char *name;
 module_param(name, charp, 0);
-- 
1.9.1

