Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaHKKJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:09:21 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:46777 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaHKKJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:09:18 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v2 0/3] Add usb phy support for STiH41x SoCs.
Date: Mon, 11 Aug 2014 11:09:09 +0100
Message-Id: <1407751752-32383-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the on-chip PHY used for USB 1.1 and 2.0 found
on STiH415 and STiH416 consumer electronics SoC's from STMicroelectronics.

Changes since v1:
 - Change to select GENERIC_PHY rather than depends for uniformity
 - Ensure phy_provider_register is called  after PHY is created
 - Add extra commit message for MAINTAINERS patch

Peter Griffin (3):
  phy: phy-stih41x-usb: Add usb phy support for STiH41x SoCs.
  phy: phy-stih41x-usb: Add dt documentation for USB phy on STiH415/6
  MAINTAINERS: Add phy-stih41x-usb.c to ARCH/STI architecture

 .../devicetree/bindings/phy/phy-stih41x-usb.txt    |  24 +++
 MAINTAINERS                                        |   1 +
 drivers/phy/Kconfig                                |   8 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-stih41x-usb.c                      | 187 +++++++++++++++++++++
 5 files changed, 221 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-stih41x-usb.txt
 create mode 100644 drivers/phy/phy-stih41x-usb.c

-- 
1.9.1

