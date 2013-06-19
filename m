Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934756Ab3FSRxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:53:34 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:32825 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab3FSRxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:53:32 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 1/2] arm: multi_v7_defconfig: Enable Zynq UART driver
Date: Wed, 19 Jun 2013 10:53:03 -0700
Message-Id: <1371664384-24974-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1371664384-24974-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1371664384-24974-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/configs/multi_v7_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 2e67a27..d5f0d76 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -42,6 +42,8 @@ CONFIG_KEYBOARD_SPEAR=y
 CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
 CONFIG_SERIAL_OF_PLATFORM=y
+CONFIG_SERIAL_XILINX_PS_UART=y
+CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
 CONFIG_SERIAL_SIRFSOC=y
 CONFIG_SERIAL_SIRFSOC_CONSOLE=y
 CONFIG_SERIAL_VT8500=y
-- 
1.8.3.1

