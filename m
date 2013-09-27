Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab3I0GxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 02:53:01 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:65198 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3I0Gw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 02:52:59 -0400
Message-ID: <52452B47.80205@linaro.org>
Date: Fri, 27 Sep 2013 08:52:55 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Jean Pihet <jean.pihet@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL 3.12-rc2 fixes] clocksource: Several fixes for 3.12-rc2
References: <524381D2.7050604@linaro.org> <20130927054957.GC6597@gmail.com>
In-Reply-To: <20130927054957.GC6597@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 07:49 AM, Ingo Molnar wrote:
>
> * Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>
>> Hi Thomas,
>>
>> this pull request contains several fixes for the clocksource/clockevent
>> drivers:
>>
>>   - Jean Pihet fixed a missing Kconfig option preventing the Armada370/XP
>> to boot up.
>>
>>   - Magnus Damm fixed the cpumask on the em_sti driver to have the
>> broadcast timer working on a SMP system
>>
>>   - Sebastian Hesselbarth skipped the initialization of a timer for
>> uninitialized DT nodes
>>
>>   - Tomasz Figa fixed the irq affinity failing on non online cpus
>>
>> Thanks
>>    -- Daniel
>>
>> -----------------------------------------------------------------------------
>>
>> The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:
>>
>>    Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)
>>
>> are available in the git repository at:
>>
>>
>> ssh://daniel.lezcano@git.linaro.org//srv/git.linaro.org/git/people/dlezcano/linux.git
>> clockevents/3.12-rc2-fixes
>
> If you want me to pull this you'll need to send along your SSH password as
> well!

Oops ! :)

Here is the right one:

git://git.linaro.org/people/dlezcano/linux.git clockevents/3.12-rc2-fixes

Thanks
   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

