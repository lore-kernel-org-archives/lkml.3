Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab3EOKpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 06:45:51 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:20782 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3EOKpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 06:45:50 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: fixes for 3.10 #1
Date: Wed, 15 May 2013 12:45:47 +0200
Message-ID: <1368614747-1737-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

This is the first AT91 fixes pull-request for 3.10-rc.

Thanks, best regards,

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to b7a8ca5173ef9aa55fa039d7c216426ff0b25a12:

  ARM: at91: rm9200 fix time support (2013-05-15 12:37:45 +0200)

----------------------------------------------------------------
An important revert on at91rm9200 platform related
to timers that prevented the platform to boot properly.
Then one pinctrl adjustments for SPI CS and a couple of
trivial typos.

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (2):
      ARM: at91/trivial: fix model name for SAM9X25-EK
      ARM: at91: rm9200 fix time support

Ludovic Desroches (1):
      ARM: at91: dts: request only spi cs-gpios used on sama5d3x cpu module

Nicolas Ferre (1):
      ARM: at91/trivial: typo in GEM compatible string

 Documentation/devicetree/bindings/net/macb.txt |  2 +-
 arch/arm/boot/dts/at91sam9x25ek.dts            |  2 +-
 arch/arm/boot/dts/sama5d3.dtsi                 | 12 +-----------
 arch/arm/boot/dts/sama5d3xcm.dtsi              |  4 ++++
 arch/arm/mach-at91/at91rm9200_time.c           |  7 +++++--
 5 files changed, 12 insertions(+), 15 deletions(-)

-- 
Nicolas Ferre
