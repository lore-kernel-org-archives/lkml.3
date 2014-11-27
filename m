Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaK0LoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:44:13 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36845 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbaK0LoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:44:11 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, broonie@kernel.org,
        linux-spi@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 0/4] spi: st: New driver for ST's SPI Controller
Date: Thu, 27 Nov 2014 11:43:52 +0000
Message-Id: <1417088636-11994-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new driver which controls the SPI component of ST's
Synchronous Serial Controller (SSC).

Lee Jones (4):
  spi: Add new driver for STMicroelectronics' SPI Controller
  spi: st: Provide Device Tree binding documentation
  ARM: sti: Provide DT nodes for SSC[0..4]
  ARM: sti: Provide DT nodes for SBC SSC[0..2]

 Documentation/devicetree/bindings/spi/spi-st.txt |  40 ++
 arch/arm/boot/dts/stih407.dtsi                   |  85 ++++
 drivers/spi/Kconfig                              |   8 +
 drivers/spi/Makefile                             |   1 +
 drivers/spi/spi-st.c                             | 535 +++++++++++++++++++++++
 5 files changed, 669 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-st.txt
 create mode 100644 drivers/spi/spi-st.c

-- 
1.9.1

