Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaIKMq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:46:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51625 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430AbaIKMeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.990152364@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 053/131] drm/radeon: load the lm63 driver for an lm64
 thermal chip.
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5dc355325b648dc9b4cf3bea4d968de46fd59215 upstream.

Looks like the lm63 driver supports the lm64 as well.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1873,7 +1873,7 @@ static const char *thermal_controller_na
 	"adm1032",
 	"adm1030",
 	"max6649",
-	"lm64",
+	"lm63", /* lm64 */
 	"f75375",
 	"asc7xxx",
 };
@@ -1884,7 +1884,7 @@ static const char *pp_lib_thermal_contro
 	"adm1032",
 	"adm1030",
 	"max6649",
-	"lm64",
+	"lm63", /* lm64 */
 	"f75375",
 	"RV6xx",
 	"RV770",

