Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab3KCJfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 04:35:10 -0500
Received: from top.free-electrons.com ([176.31.233.9]:59060 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752424Ab3KCJfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:35:06 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: kevin.z.m.zh@gmail.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/2] Add SMP support for the Allwinner A31 SoCs
Date: Sun,  3 Nov 2013 10:30:11 +0100
Message-Id: <1383471013-21695-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

The Allwinner A31 is a quad-Cortex-A7 SoC. This patchset adds support
for the bringup of the others CPUs at startup.

Thanks,
Maxime

Maxime Ripard (2):
  ARM: sun6i: dt: Add IP needed to bring up the additional cores
  ARM: sun6i: Add SMP support for the Allwinner A31

 arch/arm/boot/dts/sun6i-a31.dtsi |  10 ++++
 arch/arm/mach-sunxi/Makefile     |   1 +
 arch/arm/mach-sunxi/common.h     |  19 +++++++
 arch/arm/mach-sunxi/headsmp.S    |  11 ++++
 arch/arm/mach-sunxi/platsmp.c    | 115 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-sunxi/sunxi.c      |   3 +
 6 files changed, 159 insertions(+)
 create mode 100644 arch/arm/mach-sunxi/common.h
 create mode 100644 arch/arm/mach-sunxi/headsmp.S
 create mode 100644 arch/arm/mach-sunxi/platsmp.c

-- 
1.8.4

