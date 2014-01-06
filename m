Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaAFPEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:04:06 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58072 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaAFPEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:04:04 -0500
Date: Mon, 6 Jan 2014 20:33:56 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 09/85] drivers: gpu: Include appropriate header file in
 mga_ioc32.c
Message-ID: <9179eb2f9280fc3ca9bc242266e2ba41a3cbdf93.1389018324.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file drivers/gpu/drm/mga/mga_drv.h in
drm/mga/mga_ioc32.c because function mga_compat_ioctl() has its
prototype declaration in the header file.

This eliminates the following warning in drm/mga/mga_ioc32.c:
drivers/gpu/drm/mga/mga_ioc32.c:207:6: warning: no previous prototype for ‘mga_compat_ioctl’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/mga/mga_ioc32.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mga/mga_ioc32.c b/drivers/gpu/drm/mga/mga_ioc32.c
index 709e90d..86b4bb8 100644
--- a/drivers/gpu/drm/mga/mga_ioc32.c
+++ b/drivers/gpu/drm/mga/mga_ioc32.c
@@ -34,6 +34,7 @@
 
 #include <drm/drmP.h>
 #include <drm/mga_drm.h>
+#include "mga_drv.h"
 
 typedef struct drm32_mga_init {
 	int func;
-- 
1.7.9.5

