Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab3IYOtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:49:50 -0400
Received: from 8bytes.org ([85.214.48.195]:47669 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab3IYOtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:49:49 -0400
From: Joerg Roedel <joro@8bytes.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Airlie <airlied@linux.ie>, Rob Clark <robdclark@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/3] MSM: Remove iommu include from drivers/gpu/drm/msm/mdp4/mdp4_kms.c
Date: Wed, 25 Sep 2013 16:49:40 +0200
Message-Id: <1380120582-9068-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Sep 25 16:49:47 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5242f80b20869274258787
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The include file has been removed and the file does not
need it anyway, so remove it. Fixes a compile error.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/gpu/drm/msm/mdp4/mdp4_kms.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/mdp4/mdp4_kms.c b/drivers/gpu/drm/msm/mdp4/mdp4_kms.c
index 5db5bba..bc7fd11 100644
--- a/drivers/gpu/drm/msm/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/mdp4/mdp4_kms.c
@@ -19,8 +19,6 @@
 #include "msm_drv.h"
 #include "mdp4_kms.h"
 
-#include <mach/iommu.h>
-
 static struct mdp4_platform_config *mdp4_get_config(struct platform_device *dev);
 
 static int mdp4_hw_init(struct msm_kms *kms)
-- 
1.7.9.5


