Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaICIBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:01:19 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:65088 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaICIBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:01:18 -0400
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
Subject: [GIT PULL] at91: defconfig for 3.18 #1
Date: Wed, 3 Sep 2014 10:01:14 +0200
Message-ID: <1409731274-23483-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

Some defconfig updates for AT91. May be included after my 4 previous
pull-requests but it is certainly not a hard dependency as it won't break
compilation anyway.

Thanks, best regards,

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-defconfig

for you to fetch changes up to 7cc5f270ee6e271df466f9d3c1c4522593002ac4:

  ARM: at91: sama5: update defconfig (2014-09-02 15:06:11 +0200)

----------------------------------------------------------------
First batch of AT91 defconfig update for 3.18:
- a dependency needed for SPI flash
- enable sound on DT platforms
- cleanup of current defconfigs:
  - addition of new PWM subsystem and related drivers
  - addition of ADC/touchscreen, watchdog or USB depending on the SoC
  - addition of power/reset drivers activated during this development cycle
  - removal of obsolete config options

----------------------------------------------------------------
Alexandre Belloni (7):
      ARM: at91: at91_dt: update defconfig
      ARM: at91: at91sam9260_9g20: update defconfig
      ARM: at91: at91sam9261_9g10: update defconfig
      ARM: at91: at91sam9263: update defconfig
      ARM: at91: at91sam9g45: update defconfig
      ARM: at91: at91sam9rl: update defconfig
      ARM: at91: sama5: update defconfig

Bo Shen (2):
      ARM: at91/at91_dt_defconfig: enable sound support
      ARM: at91/sama5_defconfig: enable sound support

Brian Norris (1):
      ARM: at91: add MTD_SPI_NOR (new dependency for M25P80)

 arch/arm/configs/at91_dt_defconfig          | 35 +++++++++++++++++++----------
 arch/arm/configs/at91sam9260_9g20_defconfig | 13 +++++------
 arch/arm/configs/at91sam9261_9g10_defconfig |  5 ++---
 arch/arm/configs/at91sam9263_defconfig      | 13 +++++------
 arch/arm/configs/at91sam9g45_defconfig      | 19 +++++++++-------
 arch/arm/configs/at91sam9rl_defconfig       | 19 +++++++++++-----
 arch/arm/configs/sama5_defconfig            | 18 ++++++++++-----
 7 files changed, 73 insertions(+), 49 deletions(-)

-- 
Nicolas Ferre
