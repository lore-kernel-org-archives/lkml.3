Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab3FLMei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:34:38 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:55315 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab3FLMeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:34:36 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH 0/3] ARM: mach-moxart: add MOXA ART SoC support
Date: Wed, 12 Jun 2013 14:34:05 +0200
Message-Id: <1371040448-28742-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set adds support for MOXA ART SoC.

Applies to arm-soc/for-next.

Note: no boot without clocksource and irqchip drivers (I'll submit these separately to the correct maintainers).

The main thread of discussion can be found here:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/168438.html

Full source (including drivers) here:
https://code.google.com/p/linux-3-10-rc1-moxart/source/list

Jonas Jensen (3):
  ARM: mach-moxart: add MOXA ART SoC files
  ARM: mach-moxart: add MOXA ART device tree files
  ARM: mach-moxart: add MOXA ART UART debug files

 arch/arm/Kconfig                           |    2 +
 arch/arm/Kconfig.debug                     |   10 +++
 arch/arm/Makefile                          |    1 +
 arch/arm/boot/dts/Makefile                 |    1 +
 arch/arm/boot/dts/moxart-uc7112lx.dts      |   89 ++++++++++++++++++++++
 arch/arm/boot/dts/moxart.dtsi              |   84 +++++++++++++++++++++
 arch/arm/configs/moxart_uc7112lx_defconfig |  112 ++++++++++++++++++++++++++++
 arch/arm/include/debug/moxart.S            |   14 ++++
 arch/arm/mach-moxart/Kconfig               |   28 +++++++
 arch/arm/mach-moxart/Makefile              |   10 +++
 arch/arm/mach-moxart/idle.c                |   21 +++++
 arch/arm/mach-moxart/moxart.c              |   23 ++++++
 12 files changed, 395 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/moxart-uc7112lx.dts
 create mode 100644 arch/arm/boot/dts/moxart.dtsi
 create mode 100644 arch/arm/configs/moxart_uc7112lx_defconfig
 create mode 100644 arch/arm/include/debug/moxart.S
 create mode 100644 arch/arm/mach-moxart/Kconfig
 create mode 100644 arch/arm/mach-moxart/Makefile
 create mode 100644 arch/arm/mach-moxart/idle.c
 create mode 100644 arch/arm/mach-moxart/moxart.c

-- 
1.7.2.5

