Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab3CONaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:30:22 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:15187 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab3CONaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:30:18 -0400
Message-ID: <51432265.2060905@atmel.com>
Date: Fri, 15 Mar 2013 14:30:13 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: cleanup + soc for 3.10 #1
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

This is a pull-request targeted to do some cleanup in AT91 Kconfig
and board-dt-xxx.c files. It will prepare the coming introduction of
our SAMA5D3 family (Atmel new Cortex-A5) that we will stack on top
of these modifications soon.

Thanks, best regards,

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-soc

for you to fetch changes up to 9317960fa38ff50ac287904e4c751a169635ecbf:

  ARM: at91: renamme rm9200 dt file (2013-03-13 17:28:14 +0100)

----------------------------------------------------------------
Simplification of Kconfig and splitting of the non-DT part.
Common pattern for DT board file naming.

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (3):
      ARM: at91: move non DT Kconfig to Kconfig.non_dt
      ARM: at91: rename board-dt to more specific name board-dt-sam9
      ARM: at91: renamme rm9200 dt file

 arch/arm/configs/at91_dt_defconfig                          |   2 +-
 arch/arm/configs/at91sam9260_defconfig                      |   2 +-
 arch/arm/configs/at91sam9g20_defconfig                      |   2 +-
 arch/arm/configs/at91sam9g45_defconfig                      |   2 +-
 arch/arm/mach-at91/Kconfig                                  | 398 +---------------------------------
 arch/arm/mach-at91/Kconfig.non_dt                           | 399 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-at91/Makefile                                 |   4 +-
 arch/arm/mach-at91/{board-rm9200-dt.c => board-dt-rm9200.c} |   0
 arch/arm/mach-at91/{board-dt.c => board-dt-sam9.c}          |   0
 9 files changed, 407 insertions(+), 402 deletions(-)
 create mode 100644 arch/arm/mach-at91/Kconfig.non_dt
 rename arch/arm/mach-at91/{board-rm9200-dt.c => board-dt-rm9200.c} (100%)
 rename arch/arm/mach-at91/{board-dt.c => board-dt-sam9.c} (100%)

-- 
Nicolas Ferre
