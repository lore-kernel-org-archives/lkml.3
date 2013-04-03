Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266Ab3DCIqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:46:38 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9995 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762155Ab3DCIqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:46:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 03 Apr 2013 01:45:40 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <linux-tegra@vger.kernel.org>, <swarren@wwwdotorg.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v2 0/7] Tegra USB PHY driver series
Date: Wed, 3 Apr 2013 14:11:35 +0530
Message-ID: <1364978502-22887-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

delta from v1:
This patch is prepared as follow up patch of TEGRA USB PHY driver
patch series being discussed at:
http://marc.info/?l=linux-tegra&m=136361016003625&w=2 

Venu Byravarasu (7):
  ARM: tegra: finalize USB EHCI and PHY bindings
  ARM: tegra: update device trees for USB binding rework
  usb: phy: tegra: Get PHY mode using DT
  usb: phy: tegra: Return correct error value provided by clk_get_sys
  usb: phy: tegra: get ULPI reset GPIO info using DT.
  usb: phy: tegra: Add error handling & clean up.
  usb: phy: registering Tegra USB PHY as platform driver

 .../bindings/usb/nvidia,tegra20-ehci.txt           |   27 +--
 .../bindings/usb/nvidia,tegra20-usb-phy.txt        |   39 +++-
 arch/arm/boot/dts/tegra20-colibri-512.dtsi         |    4 +
 arch/arm/boot/dts/tegra20-harmony.dts              |    8 +-
 arch/arm/boot/dts/tegra20-iris-512.dts             |    4 +
 arch/arm/boot/dts/tegra20-paz00.dts                |    8 +-
 arch/arm/boot/dts/tegra20-seaboard.dts             |   22 ++-
 arch/arm/boot/dts/tegra20-trimslice.dts            |   21 +-
 arch/arm/boot/dts/tegra20-ventana.dts              |    7 +-
 arch/arm/boot/dts/tegra20.dtsi                     |   46 +++-
 drivers/usb/host/ehci-tegra.c                      |   95 +++----
 drivers/usb/phy/phy-tegra-usb.c                    |  309 ++++++++++++--------
 include/linux/usb/tegra_usb_phy.h                  |    5 +-
 13 files changed, 364 insertions(+), 231 deletions(-)

