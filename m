Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbaLBPk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:40:57 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:65133 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaLBPkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:40:55 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, broonie@kernel.org,
        linux-spi@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v2 0/4] spi: st: New driver for ST's SPI Controller
Date: Tue,  2 Dec 2014 15:40:40 +0000
Message-Id: <1417534844-25080-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new driver which controls the SPI component of ST's
Synchronous Serial Controller (SSC).

v1 => v2:
- New, more specific CONFIG symbol
- Increased Runtime PM functionality
- Make use of new Pinctrl API
- Convert from SPI Bitbang => Transfer One
- Omit functionality which Core can handle
- Removal of *cough* debug code 

Lee Jones (4):
  spi: Add new driver for STMicroelectronics' SPI Controller
  spi: st: Provide Device Tree binding documentation
  ARM: sti: Provide DT nodes for SSC[0..4]
  ARM: sti: Provide DT nodes for SBC SSC[0..2]

 Documentation/devicetree/bindings/spi/spi-st.txt |  40 ++
 arch/arm/boot/dts/stih407.dtsi                   |  85 ++++
 drivers/spi/Kconfig                              |   7 +
 drivers/spi/Makefile                             |   1 +
 drivers/spi/spi-st-ssc4.c                        | 509 +++++++++++++++++++++++
 5 files changed, 642 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-st.txt
 create mode 100644 drivers/spi/spi-st-ssc4.c

-- 
1.9.1

