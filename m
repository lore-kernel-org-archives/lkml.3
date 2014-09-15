Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbaIOWyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:54:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50962 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777AbaIOWQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:16:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 152/187] drm/radeon: load the lm63 driver for an lm64 thermal chip.
Date: Mon, 15 Sep 2014 15:09:22 -0700
Message-Id: <1410818997-9432-153-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5dc355325b648dc9b4cf3bea4d968de46fd59215 upstream.

Looks like the lm63 driver supports the lm64 as well.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index dfa6412..402d463 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1963,7 +1963,7 @@ static const char *thermal_controller_names[] = {
 	"adm1032",
 	"adm1030",
 	"max6649",
-	"lm64",
+	"lm63", /* lm64 */
 	"f75375",
 	"asc7xxx",
 };
@@ -1974,7 +1974,7 @@ static const char *pp_lib_thermal_controller_names[] = {
 	"adm1032",
 	"adm1030",
 	"max6649",
-	"lm64",
+	"lm63", /* lm64 */
 	"f75375",
 	"RV6xx",
 	"RV770",
-- 
1.9.1

