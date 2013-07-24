Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab3GXPnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:43:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:53669 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab3GXPnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:43:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,736,1367996400"; 
   d="scan'208";a="350846090"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/3] mei: update ABI for fw_status register exported through sysfs
Date: Wed, 24 Jul 2013 18:41:57 +0300
Message-Id: <1374680517-30894-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374680517-30894-1-git-send-email-tomas.winkler@intel.com>
References: <1374680517-30894-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 Documentation/ABI/testing/sysfs-devices-mei | 7 +++++++
 1 file changed, 7 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-mei

diff --git a/Documentation/ABI/testing/sysfs-devices-mei b/Documentation/ABI/testing/sysfs-devices-mei
new file mode 100644
index 0000000..e6860f6
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-mei
@@ -0,0 +1,7 @@
+What:           /sys/devices/<bus-num>/<dev>/fw_status
+Date:           Jul 2013
+KernelVersion:	3.12
+Contact:        Tomas Winkler <tomas.winkler@intel.com>
+Description:	Display fw status register content for applications
+		monitors fw health. The register content is hw
+		dependent.
-- 
1.8.1.2

