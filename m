Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbbAFKiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:38:09 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:32820 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbbAFKiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:38:06 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Add support for nyan-blaze
Date: Tue,  6 Jan 2015 11:37:25 +0100
Message-Id: <1420540653-14816-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the nyan-blaze board is the HP Chromebook 14. This series reuses the DTS that we currently have for nyan-big and also contains two fixes needed to get it to feature parity.

Cheers,

Tomeu

Tomeu Vizoso (4):
  ARM: tegra: rely on bootloader pinmux programming on nyan-big
  ARM: tegra: Move out nyan-generic parts out from the nyan-big DT
  ARM: tegra: Add DTS for the nyan-blaze board
  ARM: tegra: remove wp-gpios from the generic nyan dtsi

 arch/arm/boot/dts/Makefile                |    1 +
 arch/arm/boot/dts/tegra124-nyan-big.dts   | 1127 +---------------------------
 arch/arm/boot/dts/tegra124-nyan-blaze.dts |   12 +
 arch/arm/boot/dts/tegra124-nyan.dtsi      | 1132 +++++++++++++++++++++++++++++
 4 files changed, 1148 insertions(+), 1124 deletions(-)
 create mode 100644 arch/arm/boot/dts/tegra124-nyan-blaze.dts
 create mode 100644 arch/arm/boot/dts/tegra124-nyan.dtsi

-- 
1.9.3

