Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab3FNVmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:42:22 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:50287 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3FNVmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:42:21 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: <wenyou.yang@atmel.com>, <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: soc updates for 3.11 #1
Date: Fri, 14 Jun 2013 23:42:18 +0200
Message-ID: <1371246138-22207-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

A little AT91 pull-request for patches that are more targeted to SoC/boards
modifications. It is prepared on top of the arm-soc/at91/cleanup branch.

Thanks, best regards,

The following changes since commit b3f442b0eedbc20b5ce3f4a96530588d14901199:

  ARM: at91: udpate defconfigs (2013-05-17 15:05:08 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-soc

for you to fetch changes up to 7e75545ea7fb972c3da759f92c3d0be84d1cee72:

  ARM: at91: drop rm9200dk board support (2013-06-14 23:34:11 +0200)

----------------------------------------------------------------
Two non critical fixes that can go in 3.11.
An old board removed.

----------------------------------------------------------------
Alexandre Belloni (1):
      ARM: at91: Fix link breakage when !CONFIG_PHYLIB

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: drop rm9200dk board support

Wenyou Yang (1):
      ARM: at91: Change the internal SRAM memory type MT_MEMORY_NONCACHED

 arch/arm/configs/at91rm9200_defconfig |   1 -
 arch/arm/mach-at91/Kconfig            |   1 +
 arch/arm/mach-at91/Kconfig.non_dt     |   7 --
 arch/arm/mach-at91/Makefile           |   1 -
 arch/arm/mach-at91/board-dt-sama5.c   |   3 +-
 arch/arm/mach-at91/board-rm9200dk.c   | 228 ----------------------------------
 arch/arm/mach-at91/setup.c            |   2 +-
 7 files changed, 4 insertions(+), 239 deletions(-)
 delete mode 100644 arch/arm/mach-at91/board-rm9200dk.c

-- 
Nicolas Ferre
