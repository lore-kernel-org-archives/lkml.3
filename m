Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966789AbaCUBEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:04:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331AbaCUAEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.13 108/149] drm/radeon: fix minor typos in si_dpm.c
Date: Thu, 20 Mar 2014 17:04:31 -0700
Message-Id: <20140321000440.710135192@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 407b6dfd9afa30cf963fa99bca91870e47965612 upstream.

Copy/paste typos from the ni code. Should not
have any functional change.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/si_dpm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -2396,7 +2396,7 @@ static int si_populate_sq_ramping_values
 	if (SISLANDS_DPM2_SQ_RAMP_STI_SIZE > (STI_SIZE_MASK >> STI_SIZE_SHIFT))
 		enable_sq_ramping = false;
 
-	if (NISLANDS_DPM2_SQ_RAMP_LTI_RATIO <= (LTI_RATIO_MASK >> LTI_RATIO_SHIFT))
+	if (SISLANDS_DPM2_SQ_RAMP_LTI_RATIO <= (LTI_RATIO_MASK >> LTI_RATIO_SHIFT))
 		enable_sq_ramping = false;
 
 	for (i = 0; i < state->performance_level_count; i++) {
@@ -5413,7 +5413,7 @@ static void si_populate_mc_reg_addresses
 
 	for (i = 0, j = 0; j < si_pi->mc_reg_table.last; j++) {
 		if (si_pi->mc_reg_table.valid_flag & (1 << j)) {
-			if (i >= SMC_NISLANDS_MC_REGISTER_ARRAY_SIZE)
+			if (i >= SMC_SISLANDS_MC_REGISTER_ARRAY_SIZE)
 				break;
 			mc_reg_table->address[i].s0 =
 				cpu_to_be16(si_pi->mc_reg_table.mc_reg_address[j].s0);


