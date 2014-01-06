Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaAFPeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:34:50 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:59308 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaAFPet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:34:49 -0500
Date: Mon, 6 Jan 2014 21:04:44 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 26/85] drivers: gpu: Include appropriate header file in
 radeon_legacy_encoders.c
Message-ID: <4d66dbe104da531b05b698076ef556839cf1560b.1389018325.git.rashika.kheria@gmail.com>
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

Include appropriate header file drivers/gpu/drm/radeon/radeon_asic.h in
drm/radeon/radeon_legacy_encoders.c because functions
radeon_legacy_get_backlight_level() and
radeon_legacy_set_backlight_level() have their prototype declarations in
the header file.

This eliminates the following warnings in
drm/radeon/radeon_legacy_encoders.c:
drivers/gpu/drm/radeon/radeon_legacy_encoders.c:273:1: warning: no previous prototype for ‘radeon_legacy_get_backlight_level’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_legacy_encoders.c:286:1: warning: no previous prototype for ‘radeon_legacy_set_backlight_level’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
index c89971d..71672b6 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -27,6 +27,7 @@
 #include <drm/drm_crtc_helper.h>
 #include <drm/radeon_drm.h>
 #include "radeon.h"
+#include "radeon_asic.h"
 #include "atom.h"
 #include <linux/backlight.h>
 #ifdef CONFIG_PMAC_BACKLIGHT
-- 
1.7.9.5

