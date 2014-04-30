Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbaD3CFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:05:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:57509 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493AbaD3CFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:05:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="425690209"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 19/27] ACPICA: Back port of improvements on exception code.
Date: Wed, 30 Apr 2014 10:05:34 +0800
Message-Id: <b7fe634868f694d9081a8a4a2178e4a1013ab819.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

This is the linuxize result of the following commit:
  Subject: ACPICA: Improve handling of exception code blocks.
  Split exception codes into three distinct blocks; for the main
  ASL compiler, Table compiler, and the preprocessor. This allows
  easy addition of new codes into each block without disturbing
  the others. Adds one new file, aslmessages.c

The iASL changes are not in this patch as iASL currently is not
shipped in the kernel.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/acpixf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index ac04985..2d074ba 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -207,7 +207,7 @@ ACPI_INIT_GLOBAL(u8, acpi_gbl_disable_ssdt_table_install, FALSE);
 
 /*
  * We keep track of the latest version of Windows that has been requested by
- * the BIOS.  ACPI 5.0.
+ * the BIOS. ACPI 5.0.
  */
 ACPI_INIT_GLOBAL(u8, acpi_gbl_osi_data, 0);
 
-- 
1.7.10

