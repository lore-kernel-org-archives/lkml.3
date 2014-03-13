Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaCMKGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:06:47 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:38200 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaCMKGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:06:45 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [GIT PULL] at91: DT update for 3.15 #1
Date: Thu, 13 Mar 2014 11:06:37 +0100
Message-ID: <1394705197-29992-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is one request for AT91 DT update for 3.15. A lot of forgotten bits that
are corrected here, and old DT properties that are removed, nothing really new.
I think that the little modifications to the documentation can also go the
arm-soc way: there is no fundamental change to the binding, only more coherence
added.

Thanks, best regards,

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-dt

for you to fetch changes up to 1d33a2c9e9279f1e41836effb91309c90608a0e2:

  ARM: at91/dt: at91-cosino: remove useless adc properties (2014-03-12 19:11:29 +0100)

----------------------------------------------------------------
First batch of AT91 DT material for 3.15
- activate DMA for NAND flash controller
- some binding documentation update for usba and ADC (iio) drivers
- removal of some deprecated ADC (iio) properties

----------------------------------------------------------------
Alexandre Belloni (9):
      ARM: at91/DT: atmel_usba correct atmel,vbus-gpio meaning
      Documentation: dt: iio: improve atmel-adc documentation
      Documentation: dt: iio: move arm/atmel-adc.txt to iio/adc/at91_adc.txt
      ARM: at91/dt: at91-ariag25: remove useless adc properties
      ARM: at91/dt: at91sam9260: remove useless adc properties
      ARM: at91/dt: at91sam9g45: remove useless adc properties
      ARM: at91/dt: at91sam9x5: remove useless adc properties
      ARM: at91/dt: sama5d3: remove useless adc properties
      ARM: at91/dt: at91-cosino: remove useless adc properties

Ludovic Desroches (1):
      ARM: at91: sama5d3: get rid of atmel_tsadcc driver

Nicolas Ferre (1):
      ARM: at91/DT: add NAND + DMA property

 .../{arm/atmel-adc.txt => iio/adc/at91_adc.txt}    | 33 +++++++++++-----------
 .../devicetree/bindings/usb/atmel-usb.txt          |  4 +--
 arch/arm/boot/dts/at91-ariag25.dts                 |  1 -
 arch/arm/boot/dts/at91-cosino.dtsi                 |  1 -
 arch/arm/boot/dts/at91-cosino_mega2560.dts         |  1 -
 arch/arm/boot/dts/at91sam9260.dtsi                 | 11 ++++----
 arch/arm/boot/dts/at91sam9g45.dtsi                 | 12 ++++----
 arch/arm/boot/dts/at91sam9n12.dtsi                 |  1 +
 arch/arm/boot/dts/at91sam9x5.dtsi                  | 14 +++++----
 arch/arm/boot/dts/sama5d3.dtsi                     | 28 ++++++------------
 arch/arm/boot/dts/sama5d3xdm.dtsi                  |  6 ++--
 11 files changed, 52 insertions(+), 60 deletions(-)
 rename Documentation/devicetree/bindings/{arm/atmel-adc.txt => iio/adc/at91_adc.txt} (73%)

-- 
Nicolas Ferre
