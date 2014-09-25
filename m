Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaIYPlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:41:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:38793 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbaIYPls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:41:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,597,1406617200"; 
   d="scan'208";a="605317571"
From: Octavian Purdila <octavian.purdila@intel.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, johan@kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v4 0/3] mfd: viperboard: fix cache line sharing and cleanups
Date: Thu, 25 Sep 2014 18:41:34 +0300
Message-Id: <1411659697-27258-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v3:

 * undo a whitespace change

 * one more error path cleanup

 * add commit body to the last patch

Changes since v2:
 
 * switch to using devm_ allocation

 * remove unused platform_device

Changes since v1:

 * split cache sharing fix and cleanups into separate patches


Octavian Purdila (3):
  mfd: viperboard: allocate I/O buffer separately
  mfd: viperboard: switch to devm_ allocation
  mfd: viperboard: remove unused platform_device

 drivers/mfd/viperboard.c       | 18 ++++++++----------
 include/linux/mfd/viperboard.h |  3 +--
 2 files changed, 9 insertions(+), 12 deletions(-)

-- 
1.9.1

