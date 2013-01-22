Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab3AVRuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:50:52 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:55289 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3AVRuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:50:50 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <richard.genoud@gmail.com>, <linux-arm@overkiz.com>,
        <manabian@gmail.com>, <dgilbert@interlog.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 0/6] at91: some fixes for 3.8-rc5
Date: Tue, 22 Jan 2013 18:50:40 +0100
Message-ID: <cover.1358876553.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I try to collect fixes for AT91 that can be applied during this development
cycle. Please tell me now if you have more to queue or if some of the proposed
fixes are not targetted to v3.8-final in you opinion...

Thanks, cheers,


Boris BREZILLON (1):
  ARM: at91/dts: add macb mii pinctrl config for kizbox

Jean-Christophe PLAGNIOL-VILLARD (1):
  ARM: at91: rm9200: remake the BGA as default version

Joachim Eastwood (1):
  ARM: at91: fix gpios on i2c-gpio for RM9200 DT

Richard Genoud (3):
  ARM: at91/at91-pinctrl documentation: fix typo and add some details
  ARM: at91/at91sam9x5 DTS: correct wrong PIO BANK values on u(s)arts
  ARM: at91/at91sam9x5 DTS: add SCK USART pins

 .../bindings/pinctrl/atmel,at91-pinctrl.txt        |  5 ++-
 arch/arm/boot/dts/at91rm9200.dtsi                  |  4 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                  | 44 ++++++++++++++++------
 arch/arm/boot/dts/kizbox.dts                       |  2 +
 arch/arm/mach-at91/setup.c                         |  2 +
 5 files changed, 41 insertions(+), 16 deletions(-)

-- 
1.8.0

