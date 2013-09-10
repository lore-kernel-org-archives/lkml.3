Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab3IJM70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:59:26 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:61797 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3IJMtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:49:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/38] ARM: ux500: CONFIG: Enable ST's IIO Accelerometer Sensors by default
Date: Tue, 10 Sep 2013 13:49:08 +0100
Message-Id: <1378817379-8238-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/u8500_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index 6b29109..24f88d6 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -39,6 +39,7 @@ CONFIG_BLK_DEV_RAM_SIZE=65536
 CONFIG_SENSORS_BH1780=y
 CONFIG_IIO=y
 CONFIG_IIO_ST_PRESS=y
+CONFIG_IIO_ST_ACCEL_3AXIS=y
 CONFIG_NETDEVICES=y
 CONFIG_SMSC911X=y
 CONFIG_SMSC_PHY=y
-- 
1.8.1.2

