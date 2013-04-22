Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab3DVJJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:09:29 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:29761 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3DVJJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:09:28 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: soc for 3.10 #4
Date: Mon, 22 Apr 2013 11:09:25 +0200
Message-ID: <1366621765-31315-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

Another (late) round of SoC patches for 3.10 (or, of course 3.11). I would
totally understand if you delay this series to 3.11 as the merge window is
opening in one week.

I decided to sent this pull-request to you because it deals with the common
slave DMA bindings for AT91 SoCs. It is a long-awaited feature and it can be
interesting to see it merged as soon as possible.

The last patch is not related to DMA bindings but is pretty trivial.

Tell me what you think about this...
Thanks, best regards,

The following changes since commit f5fa4098c3fcc0e504fbc0682dccd331dbbcf197:

  ARM: at91: suspend both memory controllers on at91sam9263 (2013-04-18 16:31:02 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-soc

for you to fetch changes up to a6268b86483ba91c9df3e278bbc82d665d781d9e:

  ARM: at91/sama5d34ek.dts: remove not needed compatibility string (2013-04-19 11:38:05 +0200)

----------------------------------------------------------------
DT modifications for generic slave DMA binding.
Addition of MCI and I2C DMA bindings.
A little DT machine compatibility removal for SAMA5.

----------------------------------------------------------------
Ludovic Desroches (3):
      ARM: at91: dts: set #dma-cells to the correct value
      ARM: at91: dts: add i2c dma support
      ARM: at91: dts: add MCI DMA support

Nicolas Ferre (1):
      ARM: at91/sama5d34ek.dts: remove not needed compatibility string

 arch/arm/boot/dts/at91sam9g45.dtsi |  5 +++++
 arch/arm/boot/dts/at91sam9n12.dtsi |  9 +++++++++
 arch/arm/boot/dts/at91sam9x5.dtsi  | 15 +++++++++++++++
 arch/arm/boot/dts/sama5d3.dtsi     | 19 +++++++++++++++++--
 arch/arm/boot/dts/sama5d34ek.dts   |  2 +-
 5 files changed, 47 insertions(+), 3 deletions(-)

-- 
Nicolas Ferre
