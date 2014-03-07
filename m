Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbaCGTOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:14:43 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:47242 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbaCGTOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:14:39 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC v2 09/11] ARM: multi_v7_defconfig: Adopt to UART driver renaming
Date: Fri,  7 Mar 2014 11:13:32 -0800
Message-Id: <1394219614-3197-10-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1394219614-3197-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1394219614-3197-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Xilinx UARTPS driver has been renamed to Cadence UART.  Remove
the stale Xilinx UARTPS config options and add Cadence UART instead.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
---
 arch/arm/configs/multi_v7_defconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index ee6982976d66..4054c97a97e8 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -151,8 +151,8 @@ CONFIG_SERIAL_VT8500_CONSOLE=y
 CONFIG_SERIAL_OF_PLATFORM=y
 CONFIG_SERIAL_OMAP=y
 CONFIG_SERIAL_OMAP_CONSOLE=y
-CONFIG_SERIAL_XILINX_PS_UART=y
-CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
+CONFIG_SERIAL_CADENCE_UART=y
+CONFIG_SERIAL_CADENCE_UART_CONSOLE=y
 CONFIG_SERIAL_FSL_LPUART=y
 CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
 CONFIG_SERIAL_ST_ASC=y
-- 
1.9.0.1.g4196000

