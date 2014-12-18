Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaLRWqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:46:25 -0500
Received: from mga03.intel.com ([134.134.136.65]:3641 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaLRWqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:46:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,603,1413270000"; 
   d="scan'208";a="626252202"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc V2 RESEND] mei: add ABI documentation for fw_status exported through sysfs
Date: Fri, 19 Dec 2014 00:44:59 +0200
Message-Id: <1418942699-18751-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: rephrase the description

 Documentation/ABI/testing/sysfs-class-mei | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-mei b/Documentation/ABI/testing/sysfs-class-mei
index 0ec8b8178c41..80d9888a8ece 100644
--- a/Documentation/ABI/testing/sysfs-class-mei
+++ b/Documentation/ABI/testing/sysfs-class-mei
@@ -14,3 +14,18 @@ Description:
 		The /sys/class/mei/meiN directory is created for
 		each probed mei device
 
+What:		/sys/class/mei/meiN/fw_status
+Date:		Nov 2014
+KernelVersion:	3.19
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:	Display fw status registers content
+
+		The ME FW writes its status information into fw status
+		registers for BIOS and OS to monitor fw health.
+
+		The register contains running state, power management
+		state, error codes, and others. The way the registers
+		are decoded depends on PCH or SoC generation.
+		Also number of registers varies between 1 and 6
+		depending on generation.
+
-- 
1.9.3

