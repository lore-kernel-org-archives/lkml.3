Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbaK0GcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:32:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:41088 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbaK0G0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,467,1413270000"; 
   d="scan'208";a="629028337"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 4/6] ACPICA: Disassembler: Update for C-style expressions.
Date: Thu, 27 Nov 2014 14:26:21 +0800
Message-Id: <02333eb825c981d57cc4cbebd37e93b6213c679f.1416899966.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1416899966.git.lv.zheng@intel.com>
References: <cover.1416899966.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Add extra set of parens for assignments within an expression.

This patch only affects compiler support which is not in the Linux kernel.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/aclocal.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 1c218d9..80c74e9 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -829,6 +829,7 @@ struct acpi_parse_state {
 #define ACPI_PARSEOP_PREDEF_CHECKED     0x08
 #define ACPI_PARSEOP_SPECIAL            0x10
 #define ACPI_PARSEOP_COMPOUND           0x20
+#define ACPI_PARSEOP_ASSIGNMENT         0x40
 
 /*****************************************************************************
  *
-- 
1.7.10

