Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaAQRDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:03:01 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:40439 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbaAQRC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:02:57 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH] power: ds2782_battery: Typo in comment
Date: Fri, 17 Jan 2014 18:02:38 +0100
Message-Id: <1389978158-1117-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change missleading comment to actual shift value provided by the chip.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 drivers/power/ds2782_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index 5631748..041f9b6 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -192,7 +192,7 @@ static int ds2786_get_voltage(struct ds278x_info *info, int *voltage_uV)
 
 	/*
 	 * Voltage is measured in units of 1.22mV. The voltage is stored as
-	 * a 10-bit number plus sign, in the upper bits of a 16-bit register
+	 * a 12-bit number plus sign, in the upper bits of a 16-bit register
 	 */
 	err = ds278x_read_reg16(info, DS278x_REG_VOLT_MSB, &raw);
 	if (err)
-- 
1.8.1.2

