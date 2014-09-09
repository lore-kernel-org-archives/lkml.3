Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaIIJAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:00:37 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:57261 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaIIJAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:00:34 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, peppe.cavallaro@st.com,
        devicetree@vger.kernel.org
Subject: [PATCH v2 0/4] Add picoPHY usb phy driver found on stih407 family SoC's
Date: Tue,  9 Sep 2014 10:00:14 +0100
Message-Id: <1410253218-18318-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the picoPHY usb phy which is used by the usb2
and usb3 host controllers when controlling usb2/1.1 devices. It is found on
stih407 family SoC's from the consumer electronics devision of STMicroelectronics.

Changes since v1:
 - Remove reference to stih410 in dt documentation
 - Fix alignment issue in dt example
 - usbpicophy@f8 since you have a reg property

Peter Griffin (4):
  phy: phy-stih407-usb: Add usb picoPHY driver found on stih407 SoC
    family
  phy: phy-stih407-usb: Add dt documentation for USB picophy found on
    stih407 SoC family
  MAINTAINERS: Add phy-stih407-usb.c file to ARCH/STI architecture
  ARM: multi_v7_defconfig: Enable stih407 usb picophy

 .../devicetree/bindings/phy/phy-stih407-usb.txt    |  30 ++++
 MAINTAINERS                                        |   1 +
 arch/arm/configs/multi_v7_defconfig                |   1 +
 drivers/phy/Kconfig                                |   8 +
 drivers/phy/Makefile                               |   2 +
 drivers/phy/phy-stih407-usb.c                      | 185 +++++++++++++++++++++
 6 files changed, 227 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-stih407-usb.txt
 create mode 100644 drivers/phy/phy-stih407-usb.c

-- 
1.9.1

