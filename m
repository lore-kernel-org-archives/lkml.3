Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaIVTjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:39:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:47090 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbaIVTj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:39:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,573,1406617200"; 
   d="scan'208";a="577112516"
From: Octavian Purdila <octavian.purdila@intel.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, johan@kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v2 0/2] mfd: viperboard: cleanups and fix for cache line sharing
Date: Mon, 22 Sep 2014 22:39:17 +0300
Message-Id: <1411414759-7056-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:

 * split cache sharing fix and cleanups into separate patches

Octavian Purdila (2):
  mfd: viperboard: allocate I/O buffer separately
  mfd: viperboard: remove redundant OOM message and NULL pointer check

 drivers/mfd/viperboard.c       | 16 ++++++++++------
 include/linux/mfd/viperboard.h |  2 +-
 2 files changed, 11 insertions(+), 7 deletions(-)

-- 
1.9.1

