Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab3GELZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 07:25:35 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:43035 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3GELZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 07:25:33 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alex Deucher <alexander.deucher@amd.com>, David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] drm/radeon/dpm: Add missing #include <linux/seq_file.h>
Date: Fri,  5 Jul 2013 13:25:28 +0200
Message-Id: <1373023528-3361-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64_defconfig:

drivers/gpu/drm/radeon/rv6xx_dpm.c: In function 'rv6xx_dpm_debugfs_print_current_performance_level':
drivers/gpu/drm/radeon/rv6xx_dpm.c:2041:3: error: implicit declaration of function 'seq_printf' [-Werror=implicit-function-declaration]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/9068726/

 drivers/gpu/drm/radeon/rv6xx_dpm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/rv6xx_dpm.c b/drivers/gpu/drm/radeon/rv6xx_dpm.c
index 33705c5..0d09677 100644
--- a/drivers/gpu/drm/radeon/rv6xx_dpm.c
+++ b/drivers/gpu/drm/radeon/rv6xx_dpm.c
@@ -22,6 +22,7 @@
  * Authors: Alex Deucher
  */
 
+#include <linux/seq_file.h>
 #include "drmP.h"
 #include "radeon.h"
 #include "rv6xxd.h"
-- 
1.7.9.5

