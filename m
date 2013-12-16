Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3LPPns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:43:48 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58262 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab3LPPnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:43:46 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 0/4] ARM: keystone: enable GPIO support
Date: Mon, 16 Dec 2013 18:39:36 +0200
Message-ID: <1387211981-26045-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds Keystone GPIO IP definition in DT and enable GPIO support in
Keystone configuration file.

Also, it enables LEDs support for Keystone 2 K2H EVM as specified in board 
schematic. For more information see:
- http://www.advantech.com/Support/TI-EVM/EVMK2HX.aspx 

Depends on:
[PATCH 0/2] gpio: davinci: reuse for keystone arch
- https://lkml.org/lkml/2013/12/12/366

Grygorii Strashko (4):
  arm: dts: keystone: add GPIO device entry
  ARM: keystone_defconfig: enable gpio support
  arm: dts: keystone-evm: add LEDs supports
  ARM: keystone_defconfig: enable LED support

 arch/arm/boot/dts/k2hk-evm.dts      |   23 ++++++++++++++++++
 arch/arm/boot/dts/keystone.dtsi     |   45 +++++++++++++++++++++++++++++++++++
 arch/arm/configs/keystone_defconfig |   11 +++++++++
 3 files changed, 79 insertions(+)

-- 
1.7.9.5

