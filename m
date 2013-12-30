Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab3L3KnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 05:43:22 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49796 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab3L3KnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 05:43:21 -0500
Message-ID: <52C14E45.5040403@linaro.org>
Date: Mon, 30 Dec 2013 11:43:17 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [GIT PULL] clockevents/clocksources: 3.13 fixes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas and Ingo,

here is a pull request for a single fix for 3.13. It is based on the 
latest timers/urgent update.

  * Soren Brinkmann fixed the cadence_ttc driver where a call to 
clk_get_rate happens in an interrupt context. More precisely in an IPI 
when the broadcast timer is initialized for each cpu in the cpuidle driver

Thanks
   -- Daniel

The following changes since commit b0031f227e47919797dc0e1c1990f3ef151ff0cc:

   Merge tag 's2mps11-build' of 
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator 
(2013-12-17 12:57:36 -0800)

are available in the git repository at:


   git://git.linaro.org/people/daniel.lezcano/linux.git 
clockevents/3.13-fixes

for you to fetch changes up to c1dcc927dae01dfd4904ee82ce2c00b50eab6dc3:

   clocksource: cadence_ttc: Fix mutex taken inside interrupt context 
(2013-12-30 11:32:24 +0100)

----------------------------------------------------------------
Soren Brinkmann (1):
       clocksource: cadence_ttc: Fix mutex taken inside interrupt context

  drivers/clocksource/cadence_ttc_timer.c |   21 +++++++++++++--------
  1 file changed, 13 insertions(+), 8 deletions(-)


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

