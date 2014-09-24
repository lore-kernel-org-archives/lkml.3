Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbaIXROa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:14:30 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:52594 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaIXRO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:14:29 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: fixes-non-critical for 3.18 #1
Date: Wed, 24 Sep 2014 19:14:25 +0200
Message-ID: <1411578865-27232-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

If you can still pull thing before 3.18-rc1, here are some non-critical fixes.
Otherwise, they certainly can be applied during 3.18-rc phase.

Thanks, best regards,

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes-non-critical

for you to fetch changes up to cfa1950e6c6b72251e80adc736af3c3d2907ab0e:

  ARM: at91/PMC: don't forget to write PMC_PCDR register to disable clocks (2014-09-24 18:00:42 +0200)

----------------------------------------------------------------
Fixes non critical for AT91:
- mmc pinmux for at91sam9263 was missing
- little fix of the old clock implementation

----------------------------------------------------------------
Andreas Henriksson (1):
      ARM: at91: fix at91sam9263ek DT mmc pinmuxing settings

Ludovic Desroches (1):
      ARM: at91/PMC: don't forget to write PMC_PCDR register to disable clocks

 arch/arm/boot/dts/at91sam9263.dtsi | 2 ++
 arch/arm/mach-at91/clock.c         | 1 +
 2 files changed, 3 insertions(+)

-- 
Nicolas Ferre
