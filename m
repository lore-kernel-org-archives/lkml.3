Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab3BFSGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:06:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53398 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827Ab3BFSGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:06:02 -0500
Date: Wed, 6 Feb 2013 19:06:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] backlight: as3711: fix compilation breakage
Message-ID: <Pine.LNX.4.64.1302061904060.13474@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:xioJNlu0OMHg892labiN5Ru3Z+WmNm9Z3I4oz2t8ko6
 K3P8OUyEsKIsack06yI3dw77N3prLrrdgnDra1zr8QfZNP9DYB
 P+9CbjSwPeNc3c/JoOUcYJ2R16HSGcOfCObFyo0kNbJQyqBfx3
 ye/qKzJhzf4fC1b68wdOX0lVRRCxtDx9LbggQXKHKVF/uX5/pL
 yP20iMwRZupbfgs+EVJxMGcGB7tDvUtQbsc7C7bIN+PCb5qZGk
 4xbS0CyP31ebTQhf1QyYw5mczWIPza41/6g6zSbp4I/M+X1ihD
 n/kIHsQHFC6WMAjhJTFpnvGP1mKY+F//Shq5+Ystj7UM9Zjy6X
 g1piAFYN/SJzm5UnpIGGrBa1atzjiG8EdawOF7Pgp71NiFu2Xp
 YkeLz+eeK5S+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the missing platform_device.h header to fix errors like

error: implicit declaration of function 'platform_set_drvdata'

and similar.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Please, push for 3.9

 drivers/video/backlight/as3711_bl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/as3711_bl.c b/drivers/video/backlight/as3711_bl.c
index c6bc65d..41d52fe 100644
--- a/drivers/video/backlight/as3711_bl.c
+++ b/drivers/video/backlight/as3711_bl.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/mfd/as3711.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
 
-- 
1.7.2.5

