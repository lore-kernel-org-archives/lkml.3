Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbaKSPEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:04:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:47140 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929AbaKSPEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:04:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,417,1413270000"; 
   d="scan'208";a="624910815"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/3] mei: add ABI documentation for fw_status exported through sysfs
Date: Wed, 19 Nov 2014 17:01:40 +0200
Message-Id: <1416409300-14431-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416409300-14431-1-git-send-email-tomas.winkler@intel.com>
References: <1416409300-14431-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 Documentation/ABI/testing/sysfs-class-mei | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-mei b/Documentation/ABI/testing/sysfs-class-mei
index 0ec8b8178c41..61d45f03e09b 100644
--- a/Documentation/ABI/testing/sysfs-class-mei
+++ b/Documentation/ABI/testing/sysfs-class-mei
@@ -14,3 +14,11 @@ Description:
 		The /sys/class/mei/meiN directory is created for
 		each probed mei device
 
+What:		/sys/class/mei/meiN/fw_status
+Date:		Nov 2014
+KernelVersion:	3.19
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:	Display fw status registers content for applications
+		that monitor fw health. The registers meaning is platform
+		dependent.
+
-- 
1.9.3

