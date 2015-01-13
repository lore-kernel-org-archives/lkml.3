Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbbAMPYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:24:47 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:56916 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbbAMPYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:24:45 -0500
MIME-Version: 1.0
In-Reply-To: <54B52B39.1000607@linaro.org>
References: <1599190.ZYSE4SrQSK@wuerfel> <54B52B39.1000607@linaro.org>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 13 Jan 2015 23:24:24 +0800
Message-ID: <CAGsJ_4xgF5y9GQ2roh1MYSrvm+_n+fyxsUiVCp4gm+igTbdWdQ@mail.gmail.com>
Subject: Re: [PATCH] clocksource: sirf: remove unused variable
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Yanchang Li <yl22@csr.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Barry Song <Baohua.Song@csr.com>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-13 22:27 GMT+08:00 Daniel Lezcano <daniel.lezcano@linaro.org>:
> On 01/13/2015 03:22 PM, Arnd Bergmann wrote:
>>
>> A recent rework of the driver left an obviously unused variable
>> around, and now the compiler complains:
>>
>> clocksource/timer-marco.c: In function 'sirfsoc_marco_timer_init':
>> clocksource/timer-marco.c:260:6: warning: unused variable 'timer_div'
>> [-Wunused-variable]
>>
>> Remove it.
>
>
> Hi Arnd,
>
> thanks for the fix. But this has been already fixed and merged in my tree
> [1].
>
>   -- Daniel
>
> [1]
> https://git.linaro.org/people/daniel.lezcano/linux.git/commitdiff/2a016d694f36fc31f7f9fede902346c5895702bb?hp=89de77a8c557f14d2713a1f43fbc33980e639b98
>

yes, arnd. i also asked Daniel to apply "clocksource: marco: Rename
marco to atlas7" rebased on this fix here:
https://git.linaro.org/people/daniel.lezcano/linux.git/commit/81428bbe1d8a073bb3741678ef1d3c1016119c77

so this one is excluded from my pull request for atlas7. a
pull-request from arm-soc might cause merge conflicts?

>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Fixes: ef89af1f4380b92 ("clocksource: sirf: Remove hard-coded clock rate")

-barry
