Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3ASJD3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 04:03:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:15001 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab3ASJDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:03:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,498,1355126400"; 
   d="scan'208";a="249499471"
From: Jon Mason <jon.mason@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 21/21] ntb_netdev: Update Version
Date: Sat, 19 Jan 2013 02:02:35 -0700
Message-Id: <1358586155-23322-22-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
References: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update NTB netdev version to 0.7

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/net/ntb_netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index 02213a8..6ea1a7b 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -51,7 +51,7 @@
 #include <linux/pci.h>
 #include <linux/ntb.h>
 
-#define NTB_NETDEV_VER	"0.6"
+#define NTB_NETDEV_VER	"0.7"
 
 MODULE_DESCRIPTION(KBUILD_MODNAME);
 MODULE_VERSION(NTB_NETDEV_VER);
-- 
1.7.9.5

