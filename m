Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3LCI34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:29:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:15183 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab3LCI25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:28:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,816,1378882800"; 
   d="scan'208";a="445878184"
From: Aaron Lu <aaron.lu@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ACPI / fan: remove unused macro for debug
Date: Tue,  3 Dec 2013 16:28:29 +0800
Message-Id: <1386059312-2990-2-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386059312-2990-1-git-send-email-aaron.lu@intel.com>
References: <1386059312-2990-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _COMPONENT and ACPI_MODULE_NAME(name) is used for ACPI_DEBUG_PRINT,
since there is no such use in fan module we can remove them.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/acpi/fan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 1fb62900f32a..9638d28513e8 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -36,9 +36,6 @@
 #define ACPI_FAN_CLASS			"fan"
 #define ACPI_FAN_FILE_STATE		"state"
 
-#define _COMPONENT		ACPI_FAN_COMPONENT
-ACPI_MODULE_NAME("fan");
-
 MODULE_AUTHOR("Paul Diefenbaugh");
 MODULE_DESCRIPTION("ACPI Fan Driver");
 MODULE_LICENSE("GPL");
-- 
1.8.3.1

