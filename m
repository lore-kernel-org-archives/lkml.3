Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3L3LBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 06:01:08 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42680 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab3L3LBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 06:01:03 -0500
Message-ID: <52C15268.4050403@linaro.org>
Date: Mon, 30 Dec 2013 12:00:56 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Andre Przywara <andre.przywara@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [GIT PULL] ARM : cpuidle: 3.13 fix
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

this pull request provides a single fix for the calxeda cpuidle driver. 
It is based on v3.13-rc6.

* Andre Przywara fixed a compilation warning due to the driver probe 
function prototype mismatch for the calxeda cpuidle driver

Thanks
   -- Daniel

The following changes since commit 802eee95bde72fd0cd0f3a5b2098375a487d1eda:

   Linux 3.13-rc6 (2013-12-29 16:01:33 -0800)

are available in the git repository at:

   git://git.linaro.org/people/daniel.lezcano/linux.git cpuidle/3.13-fixes

for you to fetch changes up to 5781532ebecd9e0b7b5fc25d78030bdec635f4ac:

   ARM/cpuidle: remove __init tag from Calxeda cpuidle probe function 
(2013-12-30 11:55:20 +0100)

----------------------------------------------------------------
Andre Przywara (1):
       ARM/cpuidle: remove __init tag from Calxeda cpuidle probe function

  drivers/cpuidle/cpuidle-calxeda.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

