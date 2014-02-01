Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaBAMZq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 07:25:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50465 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaBAMZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 07:25:45 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <santosh.shilimkar@ti.com>
CC: <w-kwok2@ti.com>, <linux@arm.linux.org.uk>, <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v2] arm: keystone: enable watchdog support
Date: Sat, 1 Feb 2014 14:25:04 +0200
Message-ID: <1391257504-6502-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keystone SoC uses the same watchdog driver as Davinci, so
enable WDT and core used by it.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>

Conflicts:
	arch/arm/configs/keystone_defconfig
---
Rebased on
git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
keystone/master

 arch/arm/configs/keystone_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/keystone_defconfig b/arch/arm/configs/keystone_defconfig
index a018244..061ec999 100644
--- a/arch/arm/configs/keystone_defconfig
+++ b/arch/arm/configs/keystone_defconfig
@@ -131,6 +131,8 @@ CONFIG_SPI_DAVINCI=y
 CONFIG_SPI_SPIDEV=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
+CONFIG_WATCHDOG_CORE=y
+CONFIG_DAVINCI_WATCHDOG=y
 CONFIG_USB=y
 CONFIG_USB_DEBUG=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
-- 
1.8.3.2

