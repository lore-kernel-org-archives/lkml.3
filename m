Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaE0R1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:27:55 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64840 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaE0R1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:27:49 -0400
From: Lv Zheng <zetalog@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <zetalog@gmail.com>, Lv Zheng <lv.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Oswald Buddenhagen <ossi@kde.org>
Subject: [RFC PATCH 1/6] ACPICA: Hardware: Reduce divergences for sleep functions.
Date: Wed, 28 May 2014 01:27:37 +0800
Message-Id: <f8980f7d9788d609314a8ac5b6b4b1ef4a39bd89.1401210685.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1401210684.git.lv.zheng@intel.com>
References: <38907770.bupFXhytsS@vostro.rjw.lan> <cover.1401210684.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

This patch is generated to reduce source code differences between Linux and
ACPICA so that further sleep related modifications can be applied directly
without human interventions. Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Cc: Oswald Buddenhagen <ossi@kde.org>
---
 drivers/acpi/acpica/hwxfsleep.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index 6921c7f..103d9a7 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -138,7 +138,6 @@ acpi_status acpi_set_firmware_waking_vector64(u64 physical_address)
 {
 	ACPI_FUNCTION_TRACE(acpi_set_firmware_waking_vector64);
 
-
 	/* Determine if the 64-bit vector actually exists */
 
 	if ((acpi_gbl_FACS->length <= 32) || (acpi_gbl_FACS->version < 1)) {
@@ -154,7 +153,6 @@ acpi_status acpi_set_firmware_waking_vector64(u64 physical_address)
 
 ACPI_EXPORT_SYMBOL(acpi_set_firmware_waking_vector64)
 #endif
-
 /*******************************************************************************
  *
  * FUNCTION:    acpi_enter_sleep_state_s4bios
-- 
1.7.10

