Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3BDMHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:07:47 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62071 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab3BDL5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:00 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 38/73] ARM: ux500: regulator: Use device IDs instead of device names
Date: Mon,  4 Feb 2013 11:53:53 +0000
Message-Id: <1359978868-28736-39-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove device name from sensor platform data and change regulator
names according to device name.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 6b9c810..8e0679e 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -66,17 +66,17 @@ static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
 	REGULATOR_SUPPLY("vcc", "2-0029"),
 	/* lsm303dlh accelerometer */
 	REGULATOR_SUPPLY("vdd", "3-0018"),
+	/* lsm303dlhc accelerometer */
+	REGULATOR_SUPPLY("vdd", "2-0019"),
 	/* lsm303dlh magnetometer */
-	REGULATOR_SUPPLY("vdd", "3-001e"),
+	REGULATOR_SUPPLY("vdd", "2-001e"),
 	/* Rohm BU21013 Touchscreen devices */
 	REGULATOR_SUPPLY("avdd", "3-005c"),
 	REGULATOR_SUPPLY("avdd", "3-005d"),
 	/* Synaptics RMI4 Touchscreen device */
 	REGULATOR_SUPPLY("vdd", "3-004b"),
 	/* L3G4200D Gyroscope device */
-	REGULATOR_SUPPLY("vdd", "l3g4200d"),
-	/* Proximity and Hal sensor device */
-	REGULATOR_SUPPLY("vdd", "sensor1p.0"),
+	REGULATOR_SUPPLY("vdd", "2-0068"),
 	/* Ambient light sensor device */
 	REGULATOR_SUPPLY("vdd", "3-0029"),
 	/* Pressure sensor device */
-- 
1.7.9.5

