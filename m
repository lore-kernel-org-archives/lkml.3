Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaAFPUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:20:44 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57647 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaAFPUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:20:43 -0500
Date: Mon, 6 Jan 2014 20:50:38 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 21/85] drivers: gpu: Include appropriate header file in
 r128_ioc32.c
Message-ID: <d32adbc513aecf213c586096d37b70677825e436.1389018324.git.rashika.kheria@gmail.com>
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

Include appropriate header file drm/r128/r128_drv.h in
drm/r128/r128_ioc32.c because function r128_compat_ioctl() has its
prototype declaration in the header file.

This eliminates the following warning in drm/r128/r128_ioc32.c:
drivers/gpu/drm/r128/r128_ioc32.c:196:6: warning: no previous prototype for ‘r128_compat_ioctl’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/r128/r128_ioc32.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/r128/r128_ioc32.c b/drivers/gpu/drm/r128/r128_ioc32.c
index a954c54..b0d0fd3 100644
--- a/drivers/gpu/drm/r128/r128_ioc32.c
+++ b/drivers/gpu/drm/r128/r128_ioc32.c
@@ -33,6 +33,7 @@
 
 #include <drm/drmP.h>
 #include <drm/r128_drm.h>
+#include "r128_drv.h"
 
 typedef struct drm_r128_init32 {
 	int func;
-- 
1.7.9.5

