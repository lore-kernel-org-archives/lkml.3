Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbaCEPRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:17:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40945 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbaCEOZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 051/131] drm/radeon: fix minor typos in si_dpm.c
Date: Wed,  5 Mar 2014 14:22:55 +0000
Message-Id: <1394029455-23128-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 407b6dfd9afa30cf963fa99bca91870e47965612 upstream.

Copy/paste typos from the ni code. Should not
have any functional change.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/si_dpm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/si_dpm.c b/drivers/gpu/drm/radeon/si_dpm.c
index 1c23b61..e7b41c7 100644
--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -2393,7 +2393,7 @@ static int si_populate_sq_ramping_values(struct radeon_device *rdev,
 	if (SISLANDS_DPM2_SQ_RAMP_STI_SIZE > (STI_SIZE_MASK >> STI_SIZE_SHIFT))
 		enable_sq_ramping = false;
 
-	if (NISLANDS_DPM2_SQ_RAMP_LTI_RATIO <= (LTI_RATIO_MASK >> LTI_RATIO_SHIFT))
+	if (SISLANDS_DPM2_SQ_RAMP_LTI_RATIO <= (LTI_RATIO_MASK >> LTI_RATIO_SHIFT))
 		enable_sq_ramping = false;
 
 	for (i = 0; i < state->performance_level_count; i++) {
@@ -5375,7 +5375,7 @@ static void si_populate_mc_reg_addresses(struct radeon_device *rdev,
 
 	for (i = 0, j = 0; j < si_pi->mc_reg_table.last; j++) {
 		if (si_pi->mc_reg_table.valid_flag & (1 << j)) {
-			if (i >= SMC_NISLANDS_MC_REGISTER_ARRAY_SIZE)
+			if (i >= SMC_SISLANDS_MC_REGISTER_ARRAY_SIZE)
 				break;
 			mc_reg_table->address[i].s0 =
 				cpu_to_be16(si_pi->mc_reg_table.mc_reg_address[j].s0);
-- 
1.9.0

