Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaBXNda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:33:30 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41947 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaBXNd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:33:28 -0500
From: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
To: kishon@ti.com, kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: grant.likely@linaro.org, rob.herring@calxeda.com, swarren@wwwdotorg.org,
        mark.rutland@arm.com, Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Subject: [PATCH V8 0/2] Exynos5250 SATA Support
Date: Mon, 24 Feb 2014 19:02:53 +0530
Message-Id: <1393248775-3283-1-git-send-email-yuvaraj.cd@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series enable the SATA support on Exynos5250 based boards.
It incorporates the generic phy framework to deal with sata phy.

Yuvaraj Kumar C D (2):
  PHY: Exynos: Add Exynos5250 SATA PHY driver
  ARM: dts: Enable ahci sata and sata phy

 .../devicetree/bindings/ata/exynos-sata-phy.txt    |   14 --
 .../devicetree/bindings/ata/exynos-sata.txt        |   25 +-
 .../devicetree/bindings/phy/samsung-phy.txt        |   36 +++
 arch/arm/boot/dts/exynos5250-arndale.dts           |   11 +
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |    8 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |   17 +-
 drivers/phy/Kconfig                                |   15 ++
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos5250-sata.c                  |  251 ++++++++++++++++++++
 9 files changed, 345 insertions(+), 33 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
 create mode 100644 drivers/phy/phy-exynos5250-sata.c

-- 
1.7.10.4

