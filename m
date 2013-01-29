Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab3A2FTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 00:19:16 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35117 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab3A2FTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 00:19:13 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <b-cousson@ti.com>, <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <linux@arm.linux.org.uk>, <nsekhar@ti.com>,
        <khilman@deeprootsystems.com>, <hs@denx.de>, <anilkumar.v@ti.com>
Subject: [PATCH 0/2] DaVinci: da850: Add NOR flash DT node support
Date: Tue, 29 Jan 2013 10:49:54 +0530
Message-ID: <1359436796-25135-1-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add NOR flash DT node support for DA850 EVM and related pin mux.
Configure 16 bit data bus width for CS2(aemif) to use the norflash on
DA850.

This series is based on top of 3.8-rc4 and the following patches.

 -drivers/pinctrl: grab default handles from device core
  https://patchwork.kernel.org/patch/1862231/
 -ARM: davinci: da850: add pinctrl driver DT entries

Tested on DA850 EVM.

Kumar, Anil (2):
  ARM: davinci: da850 evm: add norflash DT node
  ARM: davinci: da850: configure CS2(aemif) for norflash

 arch/arm/boot/dts/da850-evm.dts  |   25 +++++++++++++++++++++++
 arch/arm/boot/dts/da850.dtsi     |   41 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-davinci/da8xx-dt.c |   17 +++++++++++++++
 3 files changed, 83 insertions(+), 0 deletions(-)

-- 
1.7.4.1

