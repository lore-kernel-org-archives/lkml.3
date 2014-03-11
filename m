Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaCKMuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:50:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:59375 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbaCKMuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:50:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,630,1389772800"; 
   d="scan'208";a="497652271"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/3] mei: drop pr_fmt macros
Date: Tue, 11 Mar 2014 14:49:24 +0200
Message-Id: <1394542165-19362-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394542165-19362-1-git-send-email-tomas.winkler@intel.com>
References: <1394542165-19362-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we are using dev_ logging facility so we don't need pr_fmt macros

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/main.c   | 3 ---
 drivers/misc/mei/pci-me.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 63ca2d1..4e069b8 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -13,9 +13,6 @@
  * more details.
  *
  */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 19fa183..135ea06 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -13,9 +13,6 @@
  * more details.
  *
  */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
-- 
1.8.5.3

