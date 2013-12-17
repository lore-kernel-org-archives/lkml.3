Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3LQPi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:38:58 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:47547 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab3LQPi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:38:56 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, arm@kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de, olof@lixom.net,
        soren.brinkmann@xilinx.com, peter.crosthwaite@xilinx.com,
        linux@roeck-us.net, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v5 0/2] ARM: mach-moxart: add MOXA ART SoC support
Date: Tue, 17 Dec 2013 16:38:32 +0100
Message-Id: <1387294714-12872-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the replies!

This should tick the boxes on your feedback.

Changes since v4:

1. remove all platform specific code
2. move all SoC common nodes (SDHCI,MAC,UART) to dtsi,
   enable them in board file
3. added moxart_defconfig options:
   CONFIG_PACKET=y
   CONFIG_IP_MULTICAST=y
4. removed moxart_defconfig options:
   # CONFIG_ARM_THUMB is not set

Applies to next-20131217

Jonas Jensen (2):
  ARM: mach-moxart: add MOXA ART SoC platform files
  ARM: mach-moxart: add MOXA ART SoC device tree files

 Documentation/devicetree/bindings/arm/moxart.txt |  12 ++
 arch/arm/Kconfig                                 |   2 +
 arch/arm/Makefile                                |   1 +
 arch/arm/boot/dts/Makefile                       |   1 +
 arch/arm/boot/dts/moxart-uc7112lx.dts            |  93 +++++++++++++
 arch/arm/boot/dts/moxart.dtsi                    | 167 +++++++++++++++++++++++
 arch/arm/configs/moxart_defconfig                | 149 ++++++++++++++++++++
 arch/arm/mach-moxart/Kconfig                     |  31 +++++
 arch/arm/mach-moxart/Makefile                    |   3 +
 arch/arm/mach-moxart/moxart.c                    |  15 ++
 10 files changed, 474 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/moxart.txt
 create mode 100644 arch/arm/boot/dts/moxart-uc7112lx.dts
 create mode 100644 arch/arm/boot/dts/moxart.dtsi
 create mode 100644 arch/arm/configs/moxart_defconfig
 create mode 100644 arch/arm/mach-moxart/Kconfig
 create mode 100644 arch/arm/mach-moxart/Makefile
 create mode 100644 arch/arm/mach-moxart/moxart.c

-- 
1.8.2.1

