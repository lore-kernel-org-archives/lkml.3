Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab3L3VQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 16:16:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40077 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab3L3VPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 16:15:38 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH v2 6/7] drm/msm: Drop unnecessary mach include
Date: Mon, 30 Dec 2013 13:15:32 -0800
Message-Id: <1388438133-431-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
References: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file doesn't use the clk_reset() API that is exposed in
mach-msm's mach/clk.h file. Remove the include so that this
driver can be compiled as part of the multi-platform kernel.

Cc: Rob Clark <robdclark@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/msm/mdp4/mdp4_dtv_encoder.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/mdp4/mdp4_dtv_encoder.c b/drivers/gpu/drm/msm/mdp4/mdp4_dtv_encoder.c
index 5e0dcae..3799ccc 100644
--- a/drivers/gpu/drm/msm/mdp4/mdp4_dtv_encoder.c
+++ b/drivers/gpu/drm/msm/mdp4/mdp4_dtv_encoder.c
@@ -15,8 +15,6 @@
  * this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include <mach/clk.h>
-
 #include "mdp4_kms.h"
 
 #include "drm_crtc.h"
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

