Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaEWPpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:45:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38943 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaEWPpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:45:17 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <lee.jones@linaro.org>,
        <santosh.shilimkar@ti.com>, <arnd@arndb.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <grant.likely@linaro.org>
CC: <rdunlap@infradead.org>, <mturquette@linaro.org>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <olof@lixom.net>, <w-kwok2@ti.com>,
        <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <m-karicheri2@ti.com>,
        <sergei.shtylyov@cogentembedded.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [Patch v7 7/7] ARM: keystone: enable reset driver support
Date: Fri, 23 May 2014 18:43:32 +0300
Message-ID: <1400859812-5761-8-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400859812-5761-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1400859812-5761-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable reset driver support in order to have opportunity
to reboot SoC by watchdog and by software.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 arch/arm/configs/keystone_defconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/configs/keystone_defconfig b/arch/arm/configs/keystone_defconfig
index 07b4327..dc0da3f 100644
--- a/arch/arm/configs/keystone_defconfig
+++ b/arch/arm/configs/keystone_defconfig
@@ -132,6 +132,9 @@ CONFIG_SPI=y
 CONFIG_SPI_DAVINCI=y
 CONFIG_SPI_SPIDEV=y
 # CONFIG_HWMON is not set
+CONFIG_POWER_SUPPLY=y
+CONFIG_POWER_RESET=y
+CONFIG_POWER_RESET_KEYSTONE=y
 CONFIG_WATCHDOG=y
 CONFIG_WATCHDOG_CORE=y
 CONFIG_DAVINCI_WATCHDOG=y
-- 
1.8.3.2

