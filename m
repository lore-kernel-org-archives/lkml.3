Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbbAUMd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:33:29 -0500
Received: from mga14.intel.com ([192.55.52.115]:25627 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbbAUMdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:33:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,441,1418112000"; 
   d="scan'208";a="640374260"
Date: Wed, 21 Jan 2015 20:32:11 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Ben Goz <ben.goz@amd.com>
Cc: kbuild-all@01.org, Oded Gabbay <oded.gabbay@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH drm-intel] drm/radeon: cik_sdma_ctx_switch_enable() can be
 static
Message-ID: <20150121123211.GA62066@lkp-sb04>
References: <201501212004.wXNTOWyN%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501212004.wXNTOWyN%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpu/drm/radeon/cik_sdma.c:293:6: sparse: symbol 'cik_sdma_ctx_switch_enable' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 cik_sdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cik_sdma.c b/drivers/gpu/drm/radeon/cik_sdma.c
index 1f4ded1..de137d1 100644
--- a/drivers/gpu/drm/radeon/cik_sdma.c
+++ b/drivers/gpu/drm/radeon/cik_sdma.c
@@ -290,7 +290,7 @@ static void cik_sdma_rlc_stop(struct radeon_device *rdev)
  *
  * Halt or unhalt the async dma engines (CIK).
  */
-void cik_sdma_ctx_switch_enable(struct radeon_device *rdev, bool enable)
+static void cik_sdma_ctx_switch_enable(struct radeon_device *rdev, bool enable)
 {
 	uint32_t reg_offset, value;
 	int i;
