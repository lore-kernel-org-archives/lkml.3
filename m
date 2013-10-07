Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab3JGOvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 10:51:07 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:59077 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3JGOvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 10:51:05 -0400
Message-ID: <5252CA58.700@linaro.org>
Date: Mon, 07 Oct 2013 16:51:04 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Linux PM mailing list <linux-pm@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [GIT PULL] cpuidle ARM: new material for 3.13
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Rafael,

this pull request based on 3.12-rc4 contains the following changes:

- Daniel Lezcano converted the zynq cpuidle driver to the platform 
driver and fixed a section mismatch for ux500

- Lorenzo Pieralisi fixed the Makefile format for ARM


Thanks
-- Daniel


The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

git://git.linaro.org/people/dlezcano/linux.git cpuidle/arm-next

for you to fetch changes up to 2c2b24d9c3e96d5cf974be4559a936e7f3b50225:

ARM: ux500: cpuidle: fix section mismatch (2013-10-07 16:47:07 +0200)

----------------------------------------------------------------
Daniel Lezcano (3):
ARM: zynq: cpuidle: Remove useless compatibility string
ARM: zynq: cpuidle: convert to platform driver
ARM: ux500: cpuidle: fix section mismatch

Lorenzo Pieralisi (1):
drivers: cpuidle: rename ARM big.LITTLE driver config and makefile entries

arch/arm/mach-zynq/common.c | 6 ++++++
drivers/cpuidle/Kconfig.arm | 22 +++++++++++-----------
drivers/cpuidle/Makefile | 2 +-
drivers/cpuidle/cpuidle-ux500.c | 2 +-
drivers/cpuidle/cpuidle-zynq.c | 17 +++++++++++------
5 files changed, 30 insertions(+), 19 deletions(-)



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

