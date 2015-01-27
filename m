Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbbA0UnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:43:13 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:39600 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbbA0UnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:43:11 -0500
Date: Tue, 27 Jan 2015 22:42:59 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, notro@tronnes.org,
        thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] staging: fbtft: fix do not initialise statics to 0 or
 NULL
Message-ID: <d6ee69bf4042fb3474d1f36d1ee3576b5fe20abc.1422296762.git.heba93aamer@gmail.com>
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
fix do not initialise statics to 0 or NULL

Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
---
 drivers/staging/fbtft/fb_pcd8544.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fbtft/fb_pcd8544.c b/drivers/staging/fbtft/fb_pcd8544.c
index d20d432..0510547 100644
--- a/drivers/staging/fbtft/fb_pcd8544.c
+++ b/drivers/staging/fbtft/fb_pcd8544.c
@@ -36,7 +36,7 @@
 #define TXBUFLEN       (84*6)
 #define DEFAULT_GAMMA  "40" /* gamma is used to control contrast in this driver */
 
-static unsigned tc = 0;
+static unsigned tc;
 module_param(tc, uint, 0);
 MODULE_PARM_DESC(tc, "TC[1:0] Temperature coefficient: 0-3 (default: 0)");
 
-- 
1.7.9.5

