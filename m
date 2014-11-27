Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbaK0G1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:27:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:41151 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbaK0G04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="422135597"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>,
        "David E. Box" <david.e.box@linux.intel.com>
Subject: [PATCH 5/6] ACPICA: Disassembler: Emit correct string for 0 stop bits.
Date: Thu, 27 Nov 2014 14:26:28 +0800
Message-Id: <6a3b2fcc1aaad67e0a02ee24402db0d284948a84.1416899966.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1416899966.git.lv.zheng@intel.com>
References: <cover.1416899966.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Was stop_bits_none, corrected to stop_bits_zero.
David E. Box.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/utresrc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/utresrc.c b/drivers/acpi/acpica/utresrc.c
index 5cd017c..bc1ff82 100644
--- a/drivers/acpi/acpica/utresrc.c
+++ b/drivers/acpi/acpica/utresrc.c
@@ -263,7 +263,7 @@ const char *acpi_gbl_bpb_decode[] = {
 /* UART serial bus stop bits */
 
 const char *acpi_gbl_sb_decode[] = {
-	"StopBitsNone",
+	"StopBitsZero",
 	"StopBitsOne",
 	"StopBitsOnePlusHalf",
 	"StopBitsTwo"
-- 
1.7.10

