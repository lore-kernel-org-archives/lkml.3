Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaLCWkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:40:24 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:65300 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaLCWkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:40:22 -0500
From: vishnupatekar <vishnupatekar0510@gmail.com>
X-Google-Original-From: vishnupatekar <VishnuPatekar0510@gmail.com>
To: maxime.ripard@free-electrons.com, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        vishnupatekar <VishnuPatekar0510@gmail.com>
Subject: [PATCH 0/3] ARM:sun7i:ps2 added support for A20 PS/2 host controller
Date: Thu,  4 Dec 2014 04:09:21 +0530
Message-Id: <1417646361-27610-1-git-send-email-VishnuPatekar0510@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for Allwinner's A20 PS2 host controller driver.
I've done basic testing on A20 Lime 2 Board.
This needs to be further tested.

Patch 0 Summary: Allwinner A20 PS2 is dual role controller(PS2 host and PS2 device). These modifications are for PS2 host controller.
IBM compliant IBM PS2 and AT-compatible keyboard and mouse can be connected.

Patch 1 device tree bindings.

Patch 2 adds support for sun7i ps2 driver. 

Patch 3 device tree support for PS2 controller.
 1) Added ps2 nodes to the dtsi 
 2) Added ps2 pinmux to the dtsi 
 3) Added ps2 nodes to the lime2 dts file.

vishnupatekar (3):
  dts-binding: input: sun7ips2: Device tree bindings for Allwinner
    sun7i A20 PS2 host controller
  drivers:input:ps2 Added sunxi A20 ps2 driver, changed makefile and
    Kconfig
  ARM:dts:sun7i:ps2 added nodes for Sun7i A20 PS2 controller.     
    added ps2 nodes in lime2 board dts.

 .../bindings/input/allwinner,sun7i-a20-ps2.txt     |   22 ++
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts    |   10 +
 arch/arm/boot/dts/sun7i-a20.dtsi                   |   30 +-
 drivers/input/serio/Kconfig                        |    9 +
 drivers/input/serio/Makefile                       |    1 +
 drivers/input/serio/sunxi-ps2.c                    |  305 ++++++++++++++++++++
 6 files changed, 376 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/input/allwinner,sun7i-a20-ps2.txt
 create mode 100644 drivers/input/serio/sunxi-ps2.c

-- 
1.7.9.5

