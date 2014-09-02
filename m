Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaIBA2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:28:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:29561 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbaIBA10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:27:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,446,1406617200"; 
   d="scan'208";a="474510587"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Hanjun Guo <hanjun.guo@linaro.org>, Bob Moore <robert.moore@intel.com>
Subject: [PATCH 3/6] ACPICA: Headers: Add GTDT flag definitions for the timer subtable.
Date: Tue,  2 Sep 2014 08:27:19 +0800
Message-Id: <c956f63dfac832377831339b85d6a40dabfd40bf.1409617516.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1409617516.git.lv.zheng@intel.com>
References: <cover.1409617516.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hanjun Guo <hanjun.guo@linaro.org>

Mostly by Hanjun Guo <hanjun.guo@linaro.org>

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/actbl3.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/acpi/actbl3.h b/include/acpi/actbl3.h
index 787bcc8..5480cb2 100644
--- a/include/acpi/actbl3.h
+++ b/include/acpi/actbl3.h
@@ -310,10 +310,15 @@ struct acpi_gtdt_timer_entry {
 	u32 common_flags;
 };
 
+/* Flag Definitions: timer_flags and virtual_timer_flags above */
+
+#define ACPI_GTDT_GT_IRQ_MODE               (1)
+#define ACPI_GTDT_GT_IRQ_POLARITY           (1<<1)
+
 /* Flag Definitions: common_flags above */
 
-#define ACPI_GTDT_GT_IS_SECURE_TIMER    (1)
-#define ACPI_GTDT_GT_ALWAYS_ON          (1<<1)
+#define ACPI_GTDT_GT_IS_SECURE_TIMER        (1)
+#define ACPI_GTDT_GT_ALWAYS_ON              (1<<1)
 
 /* 1: SBSA Generic Watchdog Structure */
 
-- 
1.7.10

