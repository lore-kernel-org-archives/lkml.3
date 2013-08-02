Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab3HBRgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:36:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:29154 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab3HBRgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:36:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="340802477"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 14/15] NTB: Update Version
Date: Fri,  2 Aug 2013 10:35:43 -0700
Message-Id: <1375464944-27914-15-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
References: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update NTB version to 1.0

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 95603f8..9dd69d8 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -57,7 +57,7 @@
 #include "ntb_regs.h"
 
 #define NTB_NAME	"Intel(R) PCI-E Non-Transparent Bridge Driver"
-#define NTB_VER		"0.25"
+#define NTB_VER		"1.0"
 
 MODULE_DESCRIPTION(NTB_NAME);
 MODULE_VERSION(NTB_VER);
-- 
1.7.9.5

