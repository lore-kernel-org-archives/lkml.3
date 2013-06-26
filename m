Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab3FZJDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:03:04 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:2903 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3FZJDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:03:00 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: Device Tree updates for 3.11 #3
Date: Wed, 26 Jun 2013 11:02:57 +0200
Message-ID: <1372237377-20315-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

One more pull-request for AT91 DT patches.
It is focused on SPI on several SoCs and it particular the SPI+DMA addition on newer
SAMA5D3 and AT91SAM9N12.

Thanks, best regards,

The following changes since commit 24ce10e142e7b063c4ae4437dd3b290fbfafe052:

  ARM: at91: sam9m10g45ek add udc DT support (2013-06-15 00:15:22 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-dt

for you to fetch changes up to 26e3326cc04bc3fc890a95ad6cb36359372acba5:

  ARM: at91: dt: rm9200ek: add spi support (2013-06-26 10:13:39 +0200)

----------------------------------------------------------------
- more SPI DT activation for rm9200
- SPI DMA for at91sam9n12/sama5d3
And one little fix for SPI compatibility string

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (2):
      ARM: at91: dt: rm9200: add spi support
      ARM: at91: dt: rm9200ek: add spi support

Nicolas Ferre (3):
      ARM: at91/DT: fix SPI compatibility string
      ARM: at91/DT: sama5d3: add SPI DMA client infos
      ARM: at91/DT: at91sam9n12: add SPI DMA client infos

 arch/arm/boot/dts/at91rm9200.dtsi  | 20 ++++++++++++++++++++
 arch/arm/boot/dts/at91rm9200ek.dts | 10 ++++++++++
 arch/arm/boot/dts/at91sam9n12.dtsi |  6 ++++++
 arch/arm/boot/dts/sama5d3.dtsi     | 10 ++++++++--
 4 files changed, 44 insertions(+), 2 deletions(-)

-- 
Nicolas Ferre
