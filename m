Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3AXJKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:10:21 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:20315 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3AXJKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:10:11 -0500
Message-ID: <5100FA77.3020405@atmel.com>
Date: Thu, 24 Jan 2013 10:10:15 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Richard Genoud <richard.genoud@gmail.com>, <linux-arm@overkiz.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Joachim Eastwood" <manabian@gmail.com>
Subject: [GIT PULL] at91: fixes for 3.8-rc5
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

Here is the pull request related to the fixes series that I sent
earlier this week. Changes are obvious and are very constrained in
AT91-related material.

The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

  Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to 8461c2f6fdd3ef0b26f931d561435df8cae2a9a5:

  ARM: at91/dts: correct comment in at91sam9x5.dtsi for mii (2013-01-23 10:40:51 +0100)

----------------------------------------------------------------
Here are fixes for AT91 that are mainly related to device tree.
One RM9200 setup option is the only C code change.
Some documentation changes can clarify the pinctrl use.
Then, some defconfig modifications are allowing the affected platforms
to boot.

----------------------------------------------------------------
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

 Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt |  5 +--
 arch/arm/boot/dts/at91rm9200.dtsi                                |  4 +--
 arch/arm/boot/dts/at91sam9x5.dtsi                                | 60 +++++++++++++++++++++++------------
 arch/arm/boot/dts/kizbox.dts                                     |  2 ++
 arch/arm/configs/at91_dt_defconfig                               |  3 +-
 arch/arm/mach-at91/setup.c                                       |  2 ++
 6 files changed, 51 insertions(+), 25 deletions(-)

Thanks, best regards,
-- 
Nicolas Ferre
