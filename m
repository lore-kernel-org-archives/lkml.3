Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761251Ab3LIPXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:23:14 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:28122 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761195Ab3LIPXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:23:08 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: dt for 3.14 #1
Date: Mon, 9 Dec 2013 16:23:05 +0100
Message-ID: <1386602585-1927-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

First pull-request focusing on DT material for AT91 on 3.14. This one is also
based on the "cleanup" material already in arm-soc tree (at91/sama5-ccf) like
all other AT91 pull-requests for 3.14.

Thanks, best regards,

The following changes since commit b46e837d8ef1f3c777bbf9513e2cdb5d87d6c374:

  ARM: at91/dt: remove old clk material (2013-12-02 15:31:29 +0100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-dt

for you to fetch changes up to ca594844e4a53f778811c06feef60bdf36bc5fec:

  ARM: at91/at91rm9200ek.dts: rearrange nodes in address ascending order (2013-12-09 15:08:57 +0100)

----------------------------------------------------------------
First DT pull-request for 3.14
- many little corrections and documentation updates
- LCD FB Device Tree for at91sam9263 and at91sam9g45 boards
- crypto peripherals DT entries + DMA specification
- new Cosino board

----------------------------------------------------------------
Bo Shen (1):
      ARM: at91: sama5d3: enable qt1070 as a wakeup source

Boris BREZILLON (2):
      ARM: at91/dt: add ethernet phy to at91rm9200ek board
      ARM: at91/dt: add atmel,pullup-gpio to at91rm9200ek usb1 definition

Jean-Christophe PLAGNIOL-VILLARD (6):
      ARM: at91: sam9g45: add fb dt support
      ARM: at91: sam9263: add fb dt support
      ARM: at91: at9sam9m10g45ek: add dt lcd support
      ARM: at91: sam9263ek: add dt lcd support
      ARM: at91: Animeo IP: fix mtd partition table
      ARM: at91: dt: at91rm9200ek: add emac and nor flash support

Ludovic Desroches (2):
      ARM: at91: at91sam9g45: set default mmc pinctrl-names
      ARM: at91: at91sam9g45: add i2c pinctrl

Nicolas Ferre (9):
      ARM: at91/trivial: fix at91rm9200 rts/cts pinctrl definitions
      ARM: at91/dt: binding: add precision to AIC documentation
      ARM: at91/dt: binding: add missing compatibility string in SDRAM/DDR documentation
      ARM: at91/dt/trivial: use macro for AES irq type
      ARM: at91/dt/trivial: before sama5d3, Atmel MPU were using at91 prefix
      ARM: at91/dt/sama5d3: add DMA information to SHA/AES/TDES nodes
      ARM: at91: add i2c2 pinctrl speficifation to sama5d3 DT
      ARM: at91: add uart aliases to sama5d3 dtsi
      ARM: at91/at91rm9200ek.dts: rearrange nodes in address ascending order

Rodolfo Giometti (1):
      ARM: at91: add support for Cosino board series by HCE Engineering

 .../devicetree/bindings/arm/atmel-aic.txt          |   1 +
 .../devicetree/bindings/arm/atmel-at91.txt         |   3 +-
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/animeo_ip.dts                    |  31 ++----
 arch/arm/boot/dts/at91-cosino.dtsi                 | 122 +++++++++++++++++++++
 arch/arm/boot/dts/at91-cosino_mega2560.dts         |  84 ++++++++++++++
 arch/arm/boot/dts/at91rm9200.dtsi                  |   4 +-
 arch/arm/boot/dts/at91rm9200ek.dts                 |  57 ++++++++--
 arch/arm/boot/dts/at91sam9263.dtsi                 |  37 +++++++
 arch/arm/boot/dts/at91sam9263ek.dts                |  30 +++++
 arch/arm/boot/dts/at91sam9g45.dtsi                 |  67 +++++++++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |  29 +++++
 arch/arm/boot/dts/sama5d3.dtsi                     |  26 ++++-
 arch/arm/boot/dts/sama5d3_uart.dtsi                |   5 +
 arch/arm/boot/dts/sama5d3xdm.dtsi                  |   1 +
 15 files changed, 457 insertions(+), 41 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91-cosino.dtsi
 create mode 100644 arch/arm/boot/dts/at91-cosino_mega2560.dts

-- 
Nicolas Ferre
