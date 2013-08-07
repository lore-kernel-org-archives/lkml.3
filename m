Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab3HGQPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:15:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:4565 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab3HGQPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:15:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,834,1367996400"; 
   d="scan'208";a="359102170"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, rjw@sisk.pl, arjan@linux.intel.com,
        len.brown@intel.com, jacob.jun.pan@linux.intel.com, corbet@lwn.net,
        joe@perches.com,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [RFC v02 3/5] PowerCap: Added to drivers build
Date: Wed,  7 Aug 2013 09:12:43 -0700
Message-Id: <1375891965-6921-4-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375891965-6921-1-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1375891965-6921-1-git-send-email-srinivas.pandruvada@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added changes to Makefile and Kconfig to include in driver build.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/Kconfig  | 2 ++
 drivers/Makefile | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 9953a42..89ff2f8 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -166,4 +166,6 @@ source "drivers/ipack/Kconfig"
 
 source "drivers/reset/Kconfig"
 
+source "drivers/powercap/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 130abc1..e207b2d 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -152,3 +152,4 @@ obj-$(CONFIG_IIO)		+= iio/
 obj-$(CONFIG_VME_BUS)		+= vme/
 obj-$(CONFIG_IPACK_BUS)		+= ipack/
 obj-$(CONFIG_NTB)		+= ntb/
+obj-$(CONFIG_POWERCAP_SUPPORT)	+= powercap/
-- 
1.8.3.1

