Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3FRIdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:33:25 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:11164 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab3FRIdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:33:23 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: <wenyou.yang@atmel.com>, <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: non critical fixes
Date: Tue, 18 Jun 2013 10:33:21 +0200
Message-ID: <1371544401-22369-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

Refurbish of preceding "soc" pull-request for extracting fixes. Note that this
at91-fixes tag is now based on v3.10-rc5 as I have found that it is the base of
your next/fixes-non-critical branch.

Thanks, best regards,

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to 133e00116b5bc76110bcc41ded369489209b641f:

  ARM: at91: Change the internal SRAM memory type MT_MEMORY_NONCACHED (2013-06-18 10:20:30 +0200)

----------------------------------------------------------------
Two non critical fixes that can go in 3.11.

----------------------------------------------------------------
Alexandre Belloni (1):
      ARM: at91: Fix link breakage when !CONFIG_PHYLIB

Wenyou Yang (1):
      ARM: at91: Change the internal SRAM memory type MT_MEMORY_NONCACHED

 arch/arm/mach-at91/Kconfig          | 1 +
 arch/arm/mach-at91/board-dt-sama5.c | 3 ++-
 arch/arm/mach-at91/setup.c          | 2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

-- 
Nicolas Ferre
