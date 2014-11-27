Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbaK0G1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:27:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:44915 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbaK0G1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:27:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,467,1413270000"; 
   d="scan'208";a="638887397"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 6/6] ACPICA: Update version to 20141107.
Date: Thu, 27 Nov 2014 14:26:35 +0800
Message-Id: <6da3e37fc53ebdaa2ba5086d054148cb62de23b8.1416899966.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1416899966.git.lv.zheng@intel.com>
References: <cover.1416899966.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Version 20141107.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/acpixf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index ab2acf6..5ba7846 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -46,7 +46,7 @@
 
 /* Current ACPICA subsystem version in YYYYMMDD format */
 
-#define ACPI_CA_VERSION                 0x20140926
+#define ACPI_CA_VERSION                 0x20141107
 
 #include <acpi/acconfig.h>
 #include <acpi/actypes.h>
-- 
1.7.10

