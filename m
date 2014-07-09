Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaGIR3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:29:44 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:33286 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbaGIR3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:29:43 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: dt for 3.17 #1
Date: Wed, 9 Jul 2014 19:29:39 +0200
Message-ID: <1404926979-31356-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is a big pull-request concerning DT on AT91. The bulk of it is the move of
the remaining SoCs to CCF. Some fixes and little additions are also included.
Alexandre's work were taken as a pull-request: as it is my first one,
please tell me if I did the inclusion correctly.

Thanks, best regards,

The following changes since commit 4c834452aad01531db949414f94f817a86348d59:

  Linux 3.16-rc3 (2014-06-29 14:11:36 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-dt

for you to fetch changes up to bf4d997ab890c2e32f3db390bec29fdd382da174:

  Merge tag 'CCF-for-3.17' of git://github.com/at91linux/linux-at91 into at91-3.17-dt (2014-07-09 19:14:31 +0200)

----------------------------------------------------------------

First DT update for 3.17:
- move of crystals DT definitions to the /clocks node
- addition of clock entries for sound for CCF enabled platforms
- addition of DMA and DMA + nand on at91sam9rl
- move to CCF for all not-converted-yet AT91 SoCs: at91rm9200, at91sam9260/9g20,
  at91sam9g45 family and at91sam9263

----------------------------------------------------------------
Alexandre Belloni (39):
      ARM: at91/dt: sam9261 crystals under the clocks node
      ARM: at91/dt: sam9n12 crystals under the clocks node
      ARM: at91/dt: sam9rl crystals under the clocks node
      ARM: at91/dt: sam9x5 crystals under the clocks node
      ARM: at91/dt: sama5d3 crystals under the clocks node
      Documentation: dt: document all the atmel pmc compatibles
      ARM: at91/dt: ariag25: define crystals frequencies
      ARM: at91: prepare common clk transition for rm9200
      ARM: at91/dt: rm9200: define clocks
      ARM: at91: move at91rm9200 SoC to the CCF
      ARM: at91/dt: at91rm9200ek: define crystals frequencies
      ARM: at91: prepare common clk transition for sam9260
      ARM: at91/dt: sam9260: define clocks
      ARM: at91/dt: sam9g20: define clocks
      ARM: at91: move at91sam9260 SoCs to the CCF
      ARM: at91/dt: at91sam9g20ek: define crystals frequencies
      ARM: at91/dt: foxg20: define crystals frequencies
      ARM: at91/dt: usb_a9260: define crystals frequencies
      ARM: at91/dt: tny_a9260: define crystals frequencies
      ARM: at91/dt: qil_a9260: define crystals frequencies
      ARM: at91/dt: mpa1600: define crytals frequencies
      ARM: at91/dt: ge863-pro3: define main crystal frequency
      ARM: at91/dt: aks-cdu: define slow crytal frequency
      ARM: at91/dt: evk-pro3: define slow crytal frequency
      ARM: at91/dt: ethernut5: define crystals frequencies
      ARM: at91/dt: animeo_ip: define crystals frequencies
      ARM: at91/dt: kizbox: define main crystal frequency
      ARM: at91: prepare common clk transition for sam9g45
      ARM: at91/dt: sam9g45: define clocks
      ARM: at91: move at91sam9g45 SoC to the CCF
      ARM: at91/dt: sam9m10g45ek: define crystals frequencies
      ARM: at91/dt: pm9g45: crystals frequencies
      ARM: at91/dt: cosino define crystals frequencies
      ARM: at91: prepare common clk transition for sam9263
      ARM: at91/dt: sam9263: define clocks
      ARM: at91: move at91sam9263 SoC to the CCF
      ARM: at91/dt: sam9263ek: define crystals frequencies
      ARM: at91/dt: tny_a9263: define crystals frequencies
      ARM: at91/dt: usb_a9263: define crystals frequencies

Bo Shen (2):
      ARM: at91: sama5d3xek: switch sound to CCF
      ARM: at91: at91sam9n12ek: switch sound to CCF

Nicolas Ferre (3):
      ARM: at91/dt: add DMA controller node to at91sam9rl
      ARM: at91/dt: add NAND + DMA property for at91sam9rl
      Merge tag 'CCF-for-3.17' of git://github.com/at91linux/linux-at91 into at91-3.17-dt

 .../devicetree/bindings/arm/atmel-pmc.txt          |   5 +-
 arch/arm/boot/dts/aks-cdu.dts                      |   6 +
 arch/arm/boot/dts/animeo_ip.dts                    |   8 +
 arch/arm/boot/dts/at91-ariag25.dts                 |   8 +
 arch/arm/boot/dts/at91-cosino.dtsi                 |   8 +
 arch/arm/boot/dts/at91-foxg20.dts                  |   8 +
 arch/arm/boot/dts/at91-qil_a9260.dts               |   8 +
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        |  12 +-
 arch/arm/boot/dts/at91rm9200.dtsi                  | 304 ++++++++++++++++++
 arch/arm/boot/dts/at91rm9200ek.dts                 |   8 +
 arch/arm/boot/dts/at91sam9260.dtsi                 | 314 ++++++++++++++++++-
 arch/arm/boot/dts/at91sam9261.dtsi                 |  20 +-
 arch/arm/boot/dts/at91sam9261ek.dts                |  16 +-
 arch/arm/boot/dts/at91sam9263.dtsi                 | 311 +++++++++++++++++++
 arch/arm/boot/dts/at91sam9263ek.dts                |   8 +
 arch/arm/boot/dts/at91sam9g20.dtsi                 |  24 ++
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |   8 +
 arch/arm/boot/dts/at91sam9g45.dtsi                 | 342 ++++++++++++++++++++-
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |   8 +
 arch/arm/boot/dts/at91sam9n12.dtsi                 |  20 +-
 arch/arm/boot/dts/at91sam9n12ek.dts                |  18 +-
 arch/arm/boot/dts/at91sam9rl.dtsi                  |  32 +-
 arch/arm/boot/dts/at91sam9rlek.dts                 |  17 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  30 +-
 arch/arm/boot/dts/at91sam9x5cm.dtsi                |  12 +-
 arch/arm/boot/dts/ethernut5.dts                    |  10 +
 arch/arm/boot/dts/evk-pro3.dts                     |   6 +
 arch/arm/boot/dts/ge863-pro3.dtsi                  |   4 +
 arch/arm/boot/dts/kizbox.dts                       |   4 +
 arch/arm/boot/dts/mpa1600.dts                      |   8 +
 arch/arm/boot/dts/pm9g45.dts                       |   8 +
 arch/arm/boot/dts/sama5d3.dtsi                     |  22 +-
 arch/arm/boot/dts/sama5d3xcm.dtsi                  |  12 +-
 arch/arm/boot/dts/sama5d3xmb.dtsi                  |   2 +
 arch/arm/boot/dts/tny_a9260_common.dtsi            |   8 +
 arch/arm/boot/dts/tny_a9263.dts                    |   8 +
 arch/arm/boot/dts/usb_a9260_common.dtsi            |   8 +
 arch/arm/boot/dts/usb_a9263.dts                    |   8 +
 arch/arm/mach-at91/Kconfig                         |   4 -
 arch/arm/mach-at91/at91rm9200.c                    |   6 +-
 arch/arm/mach-at91/at91sam9260.c                   |   6 +-
 arch/arm/mach-at91/at91sam9263.c                   |   6 +-
 arch/arm/mach-at91/at91sam9g45.c                   |   6 +-
 43 files changed, 1586 insertions(+), 105 deletions(-)

-- 
Nicolas Ferre
