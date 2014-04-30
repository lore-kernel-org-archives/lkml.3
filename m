Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbaD3KYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:24:24 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:57860 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758126AbaD3KYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:24:23 -0400
Message-ID: <5360CF57.9050202@linaro.org>
Date: Wed, 30 Apr 2014 12:24:23 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Alexander Shiyan <shc_work@mail.ru>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] cpuidle: new driver for Cirrus Logic for 3.16
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Rafael,

this pull request is based on top 3.15-rc3

  * Alexander Shiyan added a new driver for the Cirrus Logic clps711x

Thanks
   -- Daniel

The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:

   Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)

are available in the git repository at:

   git://git.linaro.org/people/daniel.lezcano/linux.git cpuidle/3.16

for you to fetch changes up to 7c7f8f7f2c6bf078874e5de35d7e2c66467fc664:

   ARM: clps711x: Add cpuidle driver (2014-04-30 01:33:02 +0200)

----------------------------------------------------------------
Alexander Shiyan (1):
       ARM: clps711x: Add cpuidle driver

  drivers/cpuidle/Kconfig.arm        |    6 ++++
  drivers/cpuidle/Makefile           |    1 +
  drivers/cpuidle/cpuidle-clps711x.c |   64 
++++++++++++++++++++++++++++++++++++
  3 files changed, 71 insertions(+)
  create mode 100644 drivers/cpuidle/cpuidle-clps711x.c

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

