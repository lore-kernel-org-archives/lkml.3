Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560AbaLBX5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:57:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:17056 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933373AbaLBX5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:57:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,504,1413270000"; 
   d="scan'208";a="641611669"
Date: Wed, 3 Dec 2014 07:57:23 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: kbuild-all@01.org, Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH jbarnes] drm/i915: fence_lock can be static
Message-ID: <20141202235723.GA62825@snb.sh.intel.com>
References: <201412030700.3iFNX4sE%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201412030700.3iFNX4sE%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpu/drm/i915/i915_sync.c:43:12: sparse: symbol 'fence_lock' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 i915_sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_sync.c b/drivers/gpu/drm/i915/i915_sync.c
index 069c069..b614eea 100644
--- a/drivers/gpu/drm/i915/i915_sync.c
+++ b/drivers/gpu/drm/i915/i915_sync.c
@@ -40,7 +40,7 @@
 #include "../../../staging/android/sync.h"
 
 /* Nothing really to protect here... */
-spinlock_t fence_lock;
+static spinlock_t fence_lock;
 
 /*
  * i915 fences on sync timelines
