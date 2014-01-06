Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaAFO2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:28:40 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:59769 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaAFO2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:28:39 -0500
Date: Mon, 6 Jan 2014 19:58:28 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 01/85] drivers: gpu: Include appropriate header file in
 drm_usb.c
Message-ID: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file include/drm/drm_usb.h in drm/drm_usb.c
because functions drm_get_usb_dev(), drm_usb_init() and drm_usb_exit()
have their prototype declarations in the header file.

This eliminates the following warning in drm/drm_usb.c:
drivers/gpu/drm/drm_usb.c:5:5: warning: no previous prototype for
‘drm_get_usb_dev’ [-Wmissing-prototypes]
drivers/gpu/drm/drm_usb.c:61:5: warning: no previous prototype for
‘drm_usb_init’ [-Wmissing-prototypes]
drivers/gpu/drm/drm_usb.c:75:6: warning: no previous prototype for
‘drm_usb_exit’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/drm_usb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_usb.c b/drivers/gpu/drm/drm_usb.c
index b179b70..7b8068b 100644
--- a/drivers/gpu/drm/drm_usb.c
+++ b/drivers/gpu/drm/drm_usb.c
@@ -1,4 +1,5 @@
 #include <drm/drmP.h>
+#include <drm/drm_usb.h>
 #include <linux/usb.h>
 #include <linux/module.h>
 
-- 
1.7.9.5

