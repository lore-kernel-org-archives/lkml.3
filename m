Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaFWMLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:11:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:35399 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbaFWMLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:11:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,530,1400050800"; 
   d="scan'208";a="551977501"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next 2/3 V2] mei: sysfs: add Documentation mei class attributes
Date: Mon, 23 Jun 2014 15:10:36 +0300
Message-Id: <1403525437-4745-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403525437-4745-1-git-send-email-tomas.winkler@intel.com>
References: <1403525437-4745-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sysfs attributes Documentation entries
for /sys/class/mei

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
V2: remove default device
 Documentation/ABI/testing/sysfs-class-mei | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-mei

diff --git a/Documentation/ABI/testing/sysfs-class-mei b/Documentation/ABI/testing/sysfs-class-mei
new file mode 100644
index 0000000..0ec8b81
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-mei
@@ -0,0 +1,16 @@
+What:		/sys/class/mei/
+Date:		May 2014
+KernelVersion:	3.17
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:
+		The mei/ class sub-directory belongs to mei device class
+
+
+What:		/sys/class/mei/meiN/
+Date:		May 2014
+KernelVersion:	3.17
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:
+		The /sys/class/mei/meiN directory is created for
+		each probed mei device
+
-- 
1.9.3

