Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3AWJtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:49:03 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:34612 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3AWJtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:49:00 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <richard.genoud@gmail.com>, <linux-arm@overkiz.com>,
        <manabian@gmail.com>, <dgilbert@interlog.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 0/9 v2] at91: some fixes for 3.8-rc5
Date: Wed, 23 Jan 2013 10:48:47 +0100
Message-ID: <cover.1358934163.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A v2 of this patch series just to make sure that the patches hit the
mailing-list once...
I plan to send a pull-request later today (my time) so if you have something to
add, well, tell me by now.

Thanks for your help, bye,

Boris BREZILLON (1):
  ARM: at91/dts: add macb mii pinctrl config for kizbox

Douglas Gilbert (1):
  ARM: at91/dts: correct comment in at91sam9x5.dtsi for mii

Jean-Christophe PLAGNIOL-VILLARD (1):
  ARM: at91: rm9200: remake the BGA as default version

Joachim Eastwood (1):
  ARM: at91: fix gpios on i2c-gpio for RM9200 DT

Nicolas Ferre (2):
  ARM: at91/at91_dt_defconfig: remove memory specification to cmdline
  ARM: at91/at91_dt_defconfig: add at91sam9n12 SoC to DT defconfig

Richard Genoud (3):
  ARM: at91/at91-pinctrl documentation: fix typo and add some details
  ARM: at91/at91sam9x5 DTS: correct wrong PIO BANK values on u(s)arts
  ARM: at91/at91sam9x5 DTS: add SCK USART pins

 .../bindings/pinctrl/atmel,at91-pinctrl.txt        |  5 +-
 arch/arm/boot/dts/at91rm9200.dtsi                  |  4 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                  | 60 ++++++++++++++--------
 arch/arm/boot/dts/kizbox.dts                       |  2 +
 arch/arm/configs/at91_dt_defconfig                 |  3 +-
 arch/arm/mach-at91/setup.c                         |  2 +
 6 files changed, 51 insertions(+), 25 deletions(-)

-- 
1.8.0

