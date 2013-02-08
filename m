Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946628Ab3BHPaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 10:30:25 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:26553 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946522Ab3BHPaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 10:30:24 -0500
Message-ID: <51151A06.3020105@atmel.com>
Date: Fri, 8 Feb 2013 16:30:14 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: BELLONI Alexandre <abelloni@adeneo-embedded.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: [GIT PULL v2] at91: little cleanup for 3.9
References: <5114E32F.8030209@atmel.com>
In-Reply-To: <5114E32F.8030209@atmel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

There is a cleanup pull-request that allows us to remove
an unused AT91 board file.

This is a v2 of the pull-request, because I have included in this one a
correction of the patch: I now remove this board entry 
in at91sam9263_defconfig as well.

The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:

  Linux 3.8-rc6 (2013-02-01 12:08:14 +1100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-cleanup

for you to fetch changes up to b65adbec2d92769242e0ffe742630d88e68f7f22:

  ARM: at91: remove NEOCORE 926 board (2013-02-08 16:25:20 +0100)

----------------------------------------------------------------
Little AT91 cleanup: only remove one deprecated board.

----------------------------------------------------------------
Nicolas Ferre (1):
      ARM: at91: remove NEOCORE 926 board

 arch/arm/configs/at91sam9263_defconfig |   1 -
 arch/arm/mach-at91/Kconfig             |   6 -
 arch/arm/mach-at91/Makefile            |   1 -
 arch/arm/mach-at91/board-neocore926.c  | 387 -----------------------------------
 4 files changed, 395 deletions(-)
 delete mode 100644 arch/arm/mach-at91/board-neocore926.c

Thanks, bye,
-- 
Nicolas Ferre
