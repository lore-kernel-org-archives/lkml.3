Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaJ0VnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 17:43:24 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:64222 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaJ0VnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 17:43:22 -0400
From: Roman Byshko <rbyshko@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 0/5] ARM: sunxi: Add support for USB OTG PHY
Date: Mon, 27 Oct 2014 22:43:00 +0100
Message-Id: <cover.1414444953.git.rbyshko@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is already support for two USB phys, which are used for
USB host controllers on Allwinner SoC aka sunxi.

This patch series add support for the USB OTG phy (aka phy0).

The code has been tested on Allwinner A20 aka sun7i (Cubietruck).

Best regards,
Roman Byshko

Roman Byshko (5):
  phy: sun4i: add support for USB phy0
  ARM: dtsi: sunxi: add common VBUS regulator
  ARM: sun7i: dtsi: add support for usbphy0
  ARM: dts: sun7i: Cubietruck: override regulator pin
  ARM: dts: sun7i: Cubietruck: add power supply regulator for USB OTG
    VBUS

 arch/arm/boot/dts/sun7i-a20-cubietruck.dts     | 14 ++++++++++++++
 arch/arm/boot/dts/sun7i-a20.dtsi               |  4 ++--
 arch/arm/boot/dts/sunxi-common-regulators.dtsi | 19 +++++++++++++++++++
 drivers/phy/phy-sun4i-usb.c                    |  9 ++++++---
 4 files changed, 41 insertions(+), 5 deletions(-)

-- 
2.1.2

