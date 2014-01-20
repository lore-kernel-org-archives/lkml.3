Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaATEe1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 23:34:27 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54387 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbaATEe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 23:34:26 -0500
From: Satish Patel <satish.patel@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rob@landley.net>
CC: Satish Patel <satish.patel@ti.com>
Subject: [PATCH v2 0/5] Smart Card(SC) interface, TI USIM & NxP SC phy driver
Date: Mon, 20 Jan 2014 10:03:49 +0530
Message-ID: <1390192434-19386-1-git-send-email-satish.patel@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1:
* RFC(v1) comments are fixed

** removed "gpio_to_irq" as GPIO controller process  cell from DT and
give it to DT node
** comments on documentation
** few other comments on null checks are resolved

* BWT timing configuration is added to ti-usim driver

v1 cover letter link#
https://lkml.org/lkml/2014/1/6/250

Satish Patel (5):
  sc_phy:SmartCard(SC) PHY interface to SC controller
  misc: tda8026: Add NXP TDA8026 PHY driver
  char: ti-usim: Add driver for USIM module on AM43xx
  ARM: dts: AM43xx: DT entries added for ti-usim
  ARM: dts: AM43xx-epos-evm: DT entries  for ti-usim and phy

 Documentation/devicetree/bindings/misc/tda8026.txt |   19 +
 .../devicetree/bindings/ti-usim/ti-usim.txt        |   31 +
 Documentation/sc_phy.txt                           |  171 ++
 arch/arm/boot/dts/am4372.dtsi                      |   10 +
 arch/arm/boot/dts/am43x-epos-evm.dts               |   43 +
 drivers/char/Kconfig                               |    7 +
 drivers/char/Makefile                              |    1 +
 drivers/char/ti-usim-hw.h                          |  863 +++++++++
 drivers/char/ti-usim.c                             | 1859 ++++++++++++++++++++
 drivers/misc/Kconfig                               |    7 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/tda8026.c                             | 1255 +++++++++++++
 include/linux/sc_phy.h                             |  132 ++
 include/linux/ti-usim.h                            |   98 +
 14 files changed, 4497 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/tda8026.txt
 create mode 100644 Documentation/devicetree/bindings/ti-usim/ti-usim.txt
 create mode 100644 Documentation/sc_phy.txt
 create mode 100644 drivers/char/ti-usim-hw.h
 create mode 100644 drivers/char/ti-usim.c
 create mode 100644 drivers/misc/tda8026.c
 create mode 100644 include/linux/sc_phy.h
 create mode 100644 include/linux/ti-usim.h

