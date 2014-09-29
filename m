Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaI2MFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:05:21 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64432 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaI2MFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:05:17 -0400
From: zhang.lyra@gmail.com
To: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org,
        broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com,
        pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com,
        robh+dt@kernel.org, will.deacon@arm.com, orsonzhai@gmail.com,
        geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
Subject: [PATCH 0/6] Add Spreadtrum Shark64 SoC support
Date: Mon, 29 Sep 2014 20:04:47 +0800
Message-Id: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "chunyan.zhang" <chunyan.zhang@spreadtrum.com>

Spreadtrum is a rapid growing chip vendor providing smart phone total solutions. 
Shark64 is nominated as a SoC infrastructure that supports 4G/3G/2G standards based on ARMv8 multiple core architecture.

This patchset adds shark64 supports in arm64 device tree and implements the basic earlycon serial driver.

chunyan.zhang (6):
  Documentation: DT: Add bindings for Spreadtrum serial
  arm64: Add DTS support for Spreadtrum's Shark64 SoC
  arm64: dts/Makefile: Add support for Spreadtrum's Shark64 SoC.
  arm64: Add support for Spreadtrum's Shark64 SoC in Kconfig and defconfig
  tty/serial: add Spreadtrum's serial earlycon
  Documentation: Add entry for Spreadtrum's Shark64 SoC

 Documentation/devicetree/bindings/arm/sprd.txt     |    6 ++
 .../devicetree/bindings/serial/of-serial.txt       |    1 +
 arch/arm64/Kconfig                                 |    5 +
 arch/arm64/boot/dts/Makefile                       |    1 +
 arch/arm64/boot/dts/sprd_shark64.dts               |  110 ++++++++++++++++++++
 arch/arm64/configs/defconfig                       |    1 +
 drivers/tty/serial/Kconfig                         |   12 +++
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/serial_sprd_early.c             |   64 ++++++++++++
 9 files changed, 201 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/sprd.txt
 create mode 100644 arch/arm64/boot/dts/sprd_shark64.dts
 create mode 100644 drivers/tty/serial/serial_sprd_early.c

-- 
1.7.9.5

