Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaG3PHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:07:17 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:59174 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbaG3PHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:07:15 -0400
From: Robert Richter <rric@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Robert Richter <rrichter@cavium.com>
Subject: [PATCH 0/5] arm64, thunder: Enable Cavium Thunder SoC Family
Date: Wed, 30 Jul 2014 17:06:29 +0200
Message-Id: <1406732794-20920-1-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rrichter@cavium.com>

This initial patches enable Cavium Thunder SoC Family. The patches add
Kconfig and devicetree support and then add Thunder to the defconfig.
The last patch is unrelated to Thunder and enables the tmpfs mount
option for a more convinient use of defconfig with distros.

The Thunder system needs more enablement patches for subsystems and
devices, this includes network, ahci, gicv3/gicv3-its, pci, smmu, kvm.
We will send separate patch sets for these. All of them base on this
initial patches.

Patches are available here:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/linux.git thunder/init

Radha Mohan Chintakuntla (3):
  arm64, thunder: Add Kconfig option for Cavium Thunder SoC Family
  arm64, thunder: Add initial dts for Cavium Thunder SoC
  arm64, thunder: document devicetree bindings for Cavium Thunder SoC

Robert Richter (2):
  arm64, defconfig: Enable Cavium Thunder SoC in defconfig
  arm64, defconfig: Enable tmpfs mount option

 .../devicetree/bindings/arm/cavium-thunder.txt     |  10 +
 Documentation/devicetree/bindings/arm/cpus.txt     |   1 +
 arch/arm64/Kconfig                                 |   6 +
 arch/arm64/boot/dts/Makefile                       |   1 +
 arch/arm64/boot/dts/thunder-88xx.dts               | 387 +++++++++++++++++++++
 arch/arm64/configs/defconfig                       |   2 +
 6 files changed, 407 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/cavium-thunder.txt
 create mode 100644 arch/arm64/boot/dts/thunder-88xx.dts

-- 
2.0.1

