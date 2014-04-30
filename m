Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbaD3CGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:06:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:38896 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756834AbaD3CF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:05:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="531005577"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 18/27] ACPICA: Back port of _PRP update.
Date: Wed, 30 Apr 2014 10:05:27 +0800
Message-Id: <650910a9331f3996e18f49af429fcbceda017504.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

This patch is the linuxize result of the following commit:
  Subject: ACPICA: Add check for _PRP/_HID dependency, with error message.
  _PRP requires that a _HID appears in the same scope.

The iASL changes are not in this patch as iASL currently is not
shipped in the kernel.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/acnames.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/acpi/acnames.h b/include/acpi/acnames.h
index 3dd6e83..f0e713f 100644
--- a/include/acpi/acnames.h
+++ b/include/acpi/acnames.h
@@ -55,6 +55,7 @@
 #define METHOD_NAME__HID        "_HID"
 #define METHOD_NAME__INI        "_INI"
 #define METHOD_NAME__PLD        "_PLD"
+#define METHOD_NAME__PRP        "_PRP"
 #define METHOD_NAME__PRS        "_PRS"
 #define METHOD_NAME__PRT        "_PRT"
 #define METHOD_NAME__PRW        "_PRW"
-- 
1.7.10

