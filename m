Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab3LaQfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 11:35:47 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:48686 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab3LaQfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 11:35:45 -0500
From: jjhiblot@traphandler.com
To: nicolas.ferre@atmel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH 0/6] Device Tree support for the at91sam9261ek
Date: Tue, 31 Dec 2013 17:32:08 +0100
Message-Id: <1388507534-10570-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

Hi Nicolas,

This patch set aims at bringing a basic device tree support for the sam9261.
It's mostly based on the sam9263 stuff.
The only new thing here is the smc bus driver. It's a very simple bus driver
used to configure the EBI from the DT. I haven't documented its DT bindings yet

supported features:
* dbgu
* nand
* lcd
* ethernet
* leds

Jean-Jacques

jean-jacques hiblot (6):
  Basic Device Tree support for the at91sam9261
  at91: dt: sam9261: Added support for the lcd display
  At91: dt: Added smc bus driver
  at91: dt: sam9261: Pinmux DT entries for the SMC/EBI interface
  at91: dt: sam9261: Add an entry in the DT for the SMC/EBI bus driver.
  at91: dt: sam9261: Added DM9000 in the device tree

jean-jacques hiblot (6):
  Basic Device Tree support for the at91sam9261
  at91: dt: sam9261: Added support for the lcd display
  At91: dt: Added smc bus driver
  at91: dt: sam9261: Pinmux DT entries for the SMC/EBI interface
  at91: dt: sam9261: Add an entry in the DT for the SMC/EBI bus driver.
  at91: dt: sam9261: Added DM9000 in the device tree

 arch/arm/boot/dts/at91sam9261.dtsi       | 575 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9261ek.dts      | 159 +++++++++
 arch/arm/mach-at91/at91sam9261.c         |  16 +
 arch/arm/mach-at91/at91sam9261_devices.c |  18 +
 drivers/bus/Kconfig                      |   9 +
 drivers/bus/Makefile                     |   1 +
 drivers/bus/atmel-smc.c                  | 182 ++++++++++
 7 files changed, 960 insertions(+)
 create mode 100644 arch/arm/boot/dts/at91sam9261.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9261ek.dts
 create mode 100644 drivers/bus/atmel-smc.c

-- 
1.8.4.2

