Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaIYOny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:43:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:31554 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbaIYOnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:43:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,597,1406617200"; 
   d="scan'208";a="578908381"
From: Octavian Purdila <octavian.purdila@intel.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, johan@kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v3 0/3] mfd: viperboard: fix cache line sharing and cleanups
Date: Thu, 25 Sep 2014 17:43:14 +0300
Message-Id: <1411656197-26517-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
 
 * switch to using devm_ allocation

 * remove unused platform_device

Changes since v1:

 * split cache sharing fix and cleanups into separate patches


Octavian Purdila (3):
  mfd: viperboard: allocate I/O buffer separately
  mfd: viperboard: switch to devm_ allocation
  mfd: viperboard: remove unused platform_device

 drivers/mfd/viperboard.c       | 19 +++++++++----------
 include/linux/mfd/viperboard.h |  3 +--
 2 files changed, 10 insertions(+), 12 deletions(-)

-- 
1.9.1

