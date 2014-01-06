Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaAFPyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:54:53 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47388 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaAFPyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:54:52 -0500
Date: Mon, 6 Jan 2014 21:24:47 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 45/85] drivers: gpu: Include appropriate header file in
 atombios_encoders.c
Message-ID: <4bf62fd7c2d35aaeb0ee7968965648c46adf2157.1389018325.git.rashika.kheria@gmail.com>
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

Include appropriate header file drm/radeon/radeon_asic.h in
drm/radeon/atombios_encoders.c because it uses function declared in the
header file.

This eliminates the following warnings in
drm/radeon/atombios_encoders.c:
drivers/gpu/drm/radeon/atombios_encoders.c:74:1: warning: no previous prototype for ‘atombios_get_backlight_level’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/atombios_encoders.c:86:1: warning: no previous prototype for ‘atombios_set_backlight_level’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/atombios_encoders.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 641298d..595d573 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -27,6 +27,7 @@
 #include <drm/drm_crtc_helper.h>
 #include <drm/radeon_drm.h>
 #include "radeon.h"
+#include "radeon_asic.h"
 #include "atom.h"
 #include "atombios.h"
 #include <linux/backlight.h>
-- 
1.7.9.5

