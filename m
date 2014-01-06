Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbaAFQBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:01:08 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:38190 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaAFQBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:01:06 -0500
Date: Mon, 6 Jan 2014 21:30:58 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 49/85] drivers: gpu: Include appropriate header file in
 r600_dpm.c
Message-ID: <4620f19505ff80d882933097aee2880ee6be561e.1389018325.git.rashika.kheria@gmail.com>
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
drm/radeon/r600_dpm.c because it uses functions declared in the header
file.

This eliminates the following warnings in drm/radeon/r600_dpm.c:
drivers/gpu/drm/radeon/r600_dpm.c:707:5: warning: no previous prototype for ‘r600_dpm_pre_set_power_state’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/r600_dpm.c:712:6: warning: no previous prototype for ‘r600_dpm_post_set_power_state’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/r600_dpm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/r600_dpm.c b/drivers/gpu/drm/radeon/r600_dpm.c
index 5513d8f..405b9e9 100644
--- a/drivers/gpu/drm/radeon/r600_dpm.c
+++ b/drivers/gpu/drm/radeon/r600_dpm.c
@@ -24,6 +24,7 @@
 
 #include "drmP.h"
 #include "radeon.h"
+#include "radeon_asic.h"
 #include "r600d.h"
 #include "r600_dpm.h"
 #include "atom.h"
-- 
1.7.9.5

