Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936297AbaH1ICb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:02:31 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41476 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935486AbaH1IC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:02:27 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        kishon@ti.com, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 0/5] usb: dwc3/phy-exynos5-usbdrd: Extend support to Exynos7
Date: Thu, 28 Aug 2014 13:31:55 +0530
Message-Id: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding required support for clocks and additional VBUS regulators
to enable USB 3.0 support on Exynos7 SoC.

This series depends for ACRH_EXYNOS7 support on following series:
[PATCH 00/14] Support 64bit Cortex A57 based Exynos7 SoC
https://www.mail-archive.com/devicetree@vger.kernel.org/msg39392.html

The series is based on usb-next branch.

Vivek Gautam (5):
  usb: dwc3: exynos: Add support for SCLK present on Exynos7
  phy: exynos5-usbdrd: Add pipe-clk and utmi-clk support
  phy: exynos5-usbdrd: Add facility for VBUS-BOOST-5V supply
  usb: dwc3: Adding Kconfig dependency for Exynos7
  phy: exynos5-usbdrd: Adding Kconfig dependency for Exynos7

 .../devicetree/bindings/phy/samsung-phy.txt        |    4 ++
 drivers/phy/Kconfig                                |    2 +-
 drivers/phy/phy-exynos5-usbdrd.c                   |   51 +++++++++++++++++++-
 drivers/usb/dwc3/Kconfig                           |    2 +-
 drivers/usb/dwc3/dwc3-exynos.c                     |   16 ++++++
 5 files changed, 71 insertions(+), 4 deletions(-)

-- 
1.7.10.4

