Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449Ab3EHQJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:09:52 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:53448 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522Ab3EHQJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:09:37 -0400
From: GBGamer <npmazzuca@gmail.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        GBGamer <nicholas@mazzucastuff.com>
Subject: [PATCH] ACPI: battery: Changed leading spaces to tab
Date: Wed,  8 May 2013 09:09:29 -0700
Message-Id: <1368029369-2115-1-git-send-email-nicholas@mazzucastuff.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style problems in battery.c
---
 drivers/acpi/battery.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index e710045..3c1784b 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -663,9 +663,9 @@ static void acpi_battery_quirks(struct acpi_battery *battery)
 	if (test_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags))
 		return ;
 
-        if (battery->full_charge_capacity == 100 &&
-            battery->rate_now == ACPI_BATTERY_VALUE_UNKNOWN &&
-            battery->capacity_now >=0 && battery->capacity_now <= 100) {
+	if (battery->full_charge_capacity == 100 &&
+		battery->rate_now == ACPI_BATTERY_VALUE_UNKNOWN &&
+		battery->capacity_now >=0 && battery->capacity_now <= 100) {
 		set_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags);
 		battery->full_charge_capacity = battery->design_capacity;
 		battery->capacity_now = (battery->capacity_now *
-- 
1.7.9.5

