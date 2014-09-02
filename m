Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaIBA1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:27:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:60200 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbaIBA1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:27:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="380007703"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 1/6] ACPICA: Add _PSx names to the METHOD_NAME list.
Date: Tue,  2 Sep 2014 08:27:05 +0800
Message-Id: <26e5b831a8416d5b1f5de35f8e8ea32892ed6d04.1409617516.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1409617516.git.lv.zheng@intel.com>
References: <cover.1409617516.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Will be used by iASL.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/acnames.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/acpi/acnames.h b/include/acpi/acnames.h
index c728113..f97804b 100644
--- a/include/acpi/acnames.h
+++ b/include/acpi/acnames.h
@@ -59,6 +59,10 @@
 #define METHOD_NAME__PRS        "_PRS"
 #define METHOD_NAME__PRT        "_PRT"
 #define METHOD_NAME__PRW        "_PRW"
+#define METHOD_NAME__PS0        "_PS0"
+#define METHOD_NAME__PS1        "_PS1"
+#define METHOD_NAME__PS2        "_PS2"
+#define METHOD_NAME__PS3        "_PS3"
 #define METHOD_NAME__REG        "_REG"
 #define METHOD_NAME__SB_        "_SB_"
 #define METHOD_NAME__SEG        "_SEG"
-- 
1.7.10

