Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab3FRInp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:43:45 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:26913 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3FRInn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:43:43 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: cleanup for 3.11 #2
Date: Tue, 18 Jun 2013 10:43:40 +0200
Message-ID: <1371545020-23186-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

The patch that was remaining from my old "soc" pull-request. It is stacked on
top of the "cleanup" patches already send as recommended by Olof.

Thanks, best regards,

The following changes since commit b3f442b0eedbc20b5ce3f4a96530588d14901199:

  ARM: at91: udpate defconfigs (2013-05-17 15:05:08 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-cleanup

for you to fetch changes up to e25ac142f3c8476410a562c481e5c29efbb1cd43:

  ARM: at91: drop rm9200dk board support (2013-06-18 10:23:15 +0200)

----------------------------------------------------------------
One old board removal.

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: drop rm9200dk board support

 arch/arm/configs/at91rm9200_defconfig |   1 -
 arch/arm/mach-at91/Kconfig.non_dt     |   7 --
 arch/arm/mach-at91/Makefile           |   1 -
 arch/arm/mach-at91/board-rm9200dk.c   | 228 ----------------------------------
 4 files changed, 237 deletions(-)
 delete mode 100644 arch/arm/mach-at91/board-rm9200dk.c

-- 
Nicolas Ferre
