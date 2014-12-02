Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531AbaLBX5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:57:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:17827 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933309AbaLBX5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:57:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="424297716"
Date: Wed, 3 Dec 2014 07:57:23 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: kbuild-all@01.org, Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [jbarnes:upstream-sync-points 2/2]
 drivers/gpu/drm/i915/i915_sync.c:43:12: sparse: symbol 'fence_lock' was not
 declared. Should it be static?
Message-ID: <201412030700.3iFNX4sE%fengguang.wu@intel.com>
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

tree:   git://people.freedesktop.org/~jbarnes/linux upstream-sync-points
head:   97b242f63adaf11c3edf16b0282243cc4274eac8
commit: 97b242f63adaf11c3edf16b0282243cc4274eac8 [2/2] drm/i915: Android sync points for i915 v3
reproduce:
  # apt-get install sparse
  git checkout 97b242f63adaf11c3edf16b0282243cc4274eac8
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/gpu/drm/i915/i915_sync.c:43:12: sparse: symbol 'fence_lock' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
