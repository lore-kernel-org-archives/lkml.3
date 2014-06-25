Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbaFYQWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:22:00 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:14667 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbaFYQV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:21:59 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: <pebolle@tiscali.nl>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: fixes for 3.16 #1 (ter)
Date: Wed, 25 Jun 2014 18:21:56 +0200
Message-ID: <1403713316-28253-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

An AT91 fixes batch for 3.16 that collects mainly DT fixes in relation
to the recent move to CCF on a couple of platforms.
A Kconfig symbol fix in drivers/misc is also included.

As the previous "fixes" pull-requests will be re-spin for 3.17 and shall be
ignored, I use the same tag name "at91-fixes".

Thanks, best regards,

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to 971dc9ce106110745f246337f229013589354536:

  ARM: at91/dt: sam9261: remove slow RC osc (2014-06-25 18:00:17 +0200)

----------------------------------------------------------------
First AT91 fixes batch for 3.16:
- drivers/misc fix for Kconfig PWM symbol
- correction of several values in DT after conversion to CCF
- fix at91sam9261/at91sam9261ek mistake in slow crystal vs. slow RC osc

----------------------------------------------------------------
Alexandre Belloni (5):
      ARM: at91/dt: sam9x5: correct PLLA ICPLL and OUT values
      ARM: at91/dt: sam9n12: correct PLLA ICPLL and OUT values
      ARM: at91/dt: sam9261: correctly define mainck
      ARM: at91/dt: define sam9261ek slow crystal frequency
      ARM: at91/dt: sam9261: remove slow RC osc

Nicolas Ferre (1):
      misc: atmel_pwm: fix Kconfig symbols

 arch/arm/boot/dts/at91sam9261.dtsi  | 21 +++++++--------------
 arch/arm/boot/dts/at91sam9261ek.dts |  4 ++++
 arch/arm/boot/dts/at91sam9n12.dtsi  |  4 ++--
 arch/arm/boot/dts/at91sam9x5.dtsi   |  4 ++--
 drivers/misc/Kconfig                |  2 +-
 5 files changed, 16 insertions(+), 19 deletions(-)

-- 
Nicolas Ferre
