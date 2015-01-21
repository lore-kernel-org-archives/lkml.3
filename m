Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbbAUMdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:33:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:30214 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbbAUMdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:33:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,441,1418112000"; 
   d="scan'208";a="673401050"
Date: Wed, 21 Jan 2015 20:32:11 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Ben Goz <ben.goz@amd.com>
Cc: kbuild-all@01.org, Oded Gabbay <oded.gabbay@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [drm-intel:drm-intel-nightly 357/550]
 drivers/gpu/drm/radeon/cik_sdma.c:293:6: sparse: symbol
 'cik_sdma_ctx_switch_enable' was not declared. Should it be static?
Message-ID: <201501212004.wXNTOWyN%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tree:   git://anongit.freedesktop.org/drm-intel drm-intel-nightly
head:   0e3c37cedf582819b6dbdd0bf0b14a15d3c2e47d
commit: d7a60d8ea5cd4560e0496d2683643d2e4930e609 [357/550] drm/radeon: Enable sdma preemption
reproduce:
  # apt-get install sparse
  git checkout d7a60d8ea5cd4560e0496d2683643d2e4930e609
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/gpu/drm/radeon/cik_sdma.c:293:6: sparse: symbol 'cik_sdma_ctx_switch_enable' was not declared. Should it be static?
   drivers/gpu/drm/radeon/cik_sdma.c:471:48: sparse: cast to restricted __le32
   drivers/gpu/drm/radeon/cik_sdma.c:472:27: sparse: cast to restricted __le32
   drivers/gpu/drm/radeon/cik_sdma.c:480:48: sparse: cast to restricted __le32
   drivers/gpu/drm/radeon/cik_sdma.c:481:27: sparse: cast to restricted __le32
   drivers/gpu/drm/radeon/cik_sdma.c:651:30: sparse: incorrect type in assignment (different base types)
   drivers/gpu/drm/radeon/cik_sdma.c:651:30:    expected unsigned int volatile [unsigned] [usertype] <noident>
   drivers/gpu/drm/radeon/cik_sdma.c:651:30:    got restricted __le32 [usertype] <noident>
   drivers/gpu/drm/radeon/cik_sdma.c:666:23: sparse: cast to restricted __le32
   drivers/gpu/drm/radeon/cik_sdma.c:708:30: sparse: incorrect type in assignment (different base types)
   drivers/gpu/drm/radeon/cik_sdma.c:708:30:    expected unsigned int volatile [unsigned] [usertype] <noident>
   drivers/gpu/drm/radeon/cik_sdma.c:708:30:    got restricted __le32 [usertype] <noident>
   drivers/gpu/drm/radeon/cik_sdma.c:735:23: sparse: cast to restricted __le32

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
