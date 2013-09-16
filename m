Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab3IPQCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:02:50 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:35397 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab3IPQCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:02:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/20] ARM: ux500: CONFIG: Enable ST's IIO Sensors by default
Date: Mon, 16 Sep 2013 17:02:12 +0100
Message-Id: <1379347346-823-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379347346-823-1-git-send-email-lee.jones@linaro.org>
References: <1379347346-823-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These include; Pressure, Accelerometer, Magnetometer and Gyroscope Sensors

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/u8500_defconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index a0025dc..aaa6c0a 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -37,6 +37,11 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=65536
 CONFIG_SENSORS_BH1780=y
+CONFIG_IIO=y
+CONFIG_IIO_ST_PRESS=y
+CONFIG_IIO_ST_ACCEL_3AXIS=y
+CONFIG_IIO_ST_MAGN_3AXIS=y
+CONFIG_IIO_ST_GYRO_3AXIS=y
 CONFIG_NETDEVICES=y
 CONFIG_SMSC911X=y
 CONFIG_SMSC_PHY=y
-- 
1.8.1.2

