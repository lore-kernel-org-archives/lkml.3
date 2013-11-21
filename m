Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab3KUAW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:22:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:3193 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab3KUAWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:22:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="438872134"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH 6/9] NTB: remove duplicate defines
Date: Wed, 20 Nov 2013 17:21:27 -0700
Message-Id: <1384993290-10107-7-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
References: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Remove duplicate defines in drivers/ntb/ntb_regs.h

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_regs.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ntb/ntb_regs.h b/drivers/ntb/ntb_regs.h
index 5381b65..a689f1c 100644
--- a/drivers/ntb/ntb_regs.h
+++ b/drivers/ntb/ntb_regs.h
@@ -76,9 +76,6 @@
 #define SNB_SBAR2XLAT_OFFSET	0x0030
 #define SNB_SBAR4XLAT_OFFSET	0x0038
 #define SNB_SBAR0BASE_OFFSET	0x0040
-#define SNB_SBAR0BASE_OFFSET	0x0040
-#define SNB_SBAR2BASE_OFFSET	0x0048
-#define SNB_SBAR4BASE_OFFSET	0x0050
 #define SNB_SBAR2BASE_OFFSET	0x0048
 #define SNB_SBAR4BASE_OFFSET	0x0050
 #define SNB_NTBCNTL_OFFSET	0x0058
-- 
1.7.9.5

