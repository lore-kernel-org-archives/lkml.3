Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab3LJHvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:51:44 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:44076 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3LJHvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:51:41 -0500
Date: Tue, 10 Dec 2013 08:51:39 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hskinnemoen@gmail.com
Subject: [GIT PULL] AVR32 fixes for 3.13
Message-ID: <20131210075139.GA6555@samfundet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

please pull

git://git.kernel.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32.git for-linus

to receive the following AVR32 fixes for 3.13

Matthias Brugger (2):
      avr32: pm: Fix section mismatch
      cpufreq_ at32ap-cpufreq.c: Fix section mismatch

Eunbong Song (1):
      avr32: Kill CONFIG_MTD_PARTITIONS

Michael Opdenacker (1):
      avr32: remove deprecated IRQF_DISABLED

Paul Walmsley (1):
      avr32: favr-32: clk_round_rate() can return a zero upon error

 arch/avr32/boards/favr-32/setup.c                   | 4 +++-
 arch/avr32/configs/atngw100_defconfig               | 1 -
 arch/avr32/configs/atngw100_evklcd100_defconfig     | 1 -
 arch/avr32/configs/atngw100_evklcd101_defconfig     | 1 -
 arch/avr32/configs/atngw100_mrmt_defconfig          | 1 -
 arch/avr32/configs/atngw100mkii_defconfig           | 1 -
 arch/avr32/configs/atngw100mkii_evklcd100_defconfig | 1 -
 arch/avr32/configs/atngw100mkii_evklcd101_defconfig | 1 -
 arch/avr32/configs/atstk1002_defconfig              | 1 -
 arch/avr32/configs/atstk1003_defconfig              | 1 -
 arch/avr32/configs/atstk1004_defconfig              | 1 -
 arch/avr32/configs/atstk1006_defconfig              | 1 -
 arch/avr32/configs/favr-32_defconfig                | 1 -
 arch/avr32/configs/hammerhead_defconfig             | 1 -
 arch/avr32/configs/merisc_defconfig                 | 1 -
 arch/avr32/configs/mimc200_defconfig                | 1 -
 arch/avr32/kernel/time.c                            | 2 +-
 arch/avr32/mach-at32ap/pm.c                         | 2 +-
 drivers/cpufreq/at32ap-cpufreq.c                    | 2 +-
 19 files changed, 6 insertions(+), 19 deletions(-)

-- 
mvh
Hans-Christian Egtvedt
