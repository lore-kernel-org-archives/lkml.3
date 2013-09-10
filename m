Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3IJM7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:59:43 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:64146 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3IJMtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:49:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/38] ARM: ux500: CONFIG: Enable ST's IIO Pressure Sensors by default
Date: Tue, 10 Sep 2013 13:49:07 +0100
Message-Id: <1378817379-8238-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/u8500_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index a0025dc..6b29109 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -37,6 +37,8 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=65536
 CONFIG_SENSORS_BH1780=y
+CONFIG_IIO=y
+CONFIG_IIO_ST_PRESS=y
 CONFIG_NETDEVICES=y
 CONFIG_SMSC911X=y
 CONFIG_SMSC_PHY=y
-- 
1.8.1.2

