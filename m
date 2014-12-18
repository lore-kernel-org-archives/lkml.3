Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaLRBKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 20:10:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:42694 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbaLRBKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 20:10:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,597,1413270000"; 
   d="scan'208";a="625625115"
Date: Thu, 18 Dec 2014 09:10:01 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Rob Clark <robdclark@gmail.com>
Cc: kbuild-all@01.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [robclark:atomic-properties 5/12] drivers/gpu/drm/drm_crtc.c:1995:5:
 sparse: symbol 'get_properties' was not declared. Should it be static?
Message-ID: <201412180950.908XRX5k%fengguang.wu@intel.com>
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

tree:   git://people.freedesktop.org/~robclark/linux atomic-properties
head:   4e73d9848e88a1bdd90c2506457dc4e7583c2f58
commit: d9224ddf063bb89803a3f4cce2dfd3d2afcb4906 [5/12] drm: refactor getproperties/getconnector
reproduce:
  # apt-get install sparse
  git checkout d9224ddf063bb89803a3f4cce2dfd3d2afcb4906
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/gpu/drm/drm_crtc.c:1995:5: sparse: symbol 'get_properties' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
