Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab3FLT7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 15:59:17 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:48885 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3FLT7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 15:59:16 -0400
Message-ID: <51B8D310.4050404@linaro.org>
Date: Wed, 12 Jun 2013 21:59:12 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        ezequiel.garcia@free-electrons.com, Andrew Lunn <andrew@lunn.ch>
Subject: [GIT PULL] clockevents/clocksource: Add Marvell Orion SoC timer
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit 762cf9695d714d312ef7369bed1b9f9467c9e64e:

  Merge branch 'timers/clockevents' of
git://git.linaro.org/people/dlezcano/clockevents into timers/core
(2013-06-08 22:58:27 +0200)

are available in the git repository at:


  git://git.linaro.org/people/dlezcano/clockevents.git timers/clockevents

for you to fetch changes up to fbb3cb01505e7365c70a7fe680e10ffff3175160:

  clocksource: Add Marvell Orion SoC timer (2013-06-11 14:41:01 +0200)

----------------------------------------------------------------
Sebastian Hesselbarth (1):
      clocksource: Add Marvell Orion SoC timer

 .../bindings/timer/marvell,orion-timer.txt         |   17 +++
 drivers/clocksource/Kconfig                        |    5 +
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/time-orion.c                   |  150
++++++++++++++++++++
 4 files changed, 173 insertions(+)
 create mode 100644
Documentation/devicetree/bindings/timer/marvell,orion-timer.txt
 create mode 100644 drivers/clocksource/time-orion.c



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

