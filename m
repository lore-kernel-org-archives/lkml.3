Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbaEMIXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:23:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:52033 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759461AbaEMIXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:23:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1042,1389772800"; 
   d="scan'208";a="510767488"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next 2/3] mei: sysfs: add Documentation mei class attributes
Date: Tue, 13 May 2014 11:22:00 +0300
Message-Id: <1399969321-6512-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399969321-6512-1-git-send-email-tomas.winkler@intel.com>
References: <1399969321-6512-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sysfs attributes Documentation entries
for /sys/class/mei

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 Documentation/ABI/testing/sysfs-class-mei | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-mei

diff --git a/Documentation/ABI/testing/sysfs-class-mei b/Documentation/ABI/testing/sysfs-class-mei
new file mode 100644
index 0000000..b691c2b
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-mei
@@ -0,0 +1,23 @@
+What:		/sys/class/mei/
+Date:		May 2014
+KernelVersion:	3.16
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:
+		The mei/ class sub-directory belongs to mei device class
+
+What:		/sys/class/mei/mei/
+Date:		May 2014
+KernelVersion:	3.16
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:
+		The /sys/class/mei/mei directory is created for the default
+		mei device
+
+What:		/sys/class/mei/meiN/
+Date:		May 2014
+KernelVersion:	3.16
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:
+		The /sys/class/mei/meiN directory is created for
+		each probed non default mei device
+
-- 
1.9.0

