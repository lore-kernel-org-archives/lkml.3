Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaBGQg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:36:29 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:3101 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaBGQg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:36:28 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Boris BREZILLON <b.brezillon@overkiz.com>, <jjhiblot@traphandler.com>,
        Bo Shen <voice.shen@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: fixes for 3.14 #1
Date: Fri, 7 Feb 2014 17:36:26 +0100
Message-ID: <1391790986-31936-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is a first "fixes" series for AT91 on 3.14.
The content is only DT-related and quite boring.
I took the opportunity of this early "fixes" pull-request to collect
some Documentation patches that were lying around and I guess that
they can be merged by arm-soc nicely (addition of CCF to 2 drivers).
A new board is added to the lot because it is dead simple and integrates
well with the new sama5d36 SoC that we added earlier in this development cycle.

Thanks, best regards,

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to b7c2b6157079811586180d13c44a1095b57c2d47:

  ARM: at91: add Atmel's SAMA5D3 Xplained board (2014-02-07 17:20:39 +0100)

----------------------------------------------------------------
First series of AT91 fixes for 3.14.
All of them are DT-related.
- fixes for typos in i2c and ohci clocks
- addition of a USB host node for at91sam9n12ek
- 2 DT documentation updates that have been sent a long time ago
- a new board based on the sama5d36 SoC

----------------------------------------------------------------
Bo Shen (1):
      ARM: at91: enable USB host on at91sam9n12ek board

Boris BREZILLON (3):
      ARM: at91/dt: fix sama5d3 ohci hclk clock reference
      mmc: atmel-mci: document clock properties
      spi/atmel: document clock properties

Jean-Jacques Hiblot (1):
      ARM: at91/dt: sam9263: fix compatibility string for the I2C

Nicolas Ferre (1):
      ARM: at91: add Atmel's SAMA5D3 Xplained board

 .../devicetree/bindings/mmc/atmel-hsmci.txt        |   5 +
 .../devicetree/bindings/spi/spi_atmel.txt          |   5 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        | 229 +++++++++++++++++++++
 arch/arm/boot/dts/at91sam9263.dtsi                 |   2 +-
 arch/arm/boot/dts/at91sam9n12ek.dts                |   4 +
 arch/arm/boot/dts/sama5d3.dtsi                     |   2 +-
 7 files changed, 246 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91-sama5d3_xplained.dts

-- 
Nicolas Ferre
