Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbbAMPjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:39:31 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35624 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbbAMPja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:39:30 -0500
Message-ID: <54B53C2F.905@linaro.org>
Date: Tue, 13 Jan 2015 16:39:27 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Yanchang Li <yl22@csr.com>, Barry Song <Baohua.Song@csr.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: sirf: remove unused variable
References: <1599190.ZYSE4SrQSK@wuerfel> <54B52B39.1000607@linaro.org> <22227544.6odKQXu0TN@wuerfel>
In-Reply-To: <22227544.6odKQXu0TN@wuerfel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 04:24 PM, Arnd Bergmann wrote:
> On Tuesday 13 January 2015 15:27:05 Daniel Lezcano wrote:
>> On 01/13/2015 03:22 PM, Arnd Bergmann wrote:
>>> A recent rework of the driver left an obviously unused variable
>>> around, and now the compiler complains:
>>>
>>> clocksource/timer-marco.c: In function 'sirfsoc_marco_timer_init':
>>> clocksource/timer-marco.c:260:6: warning: unused variable 'timer_div' [-Wunused-variable]
>>>
>>> Remove it.
>>
>> Hi Arnd,
>>
>> thanks for the fix. But this has been already fixed and merged in my
>> tree [1].
>
> Ok, thanks. For some reason it has not shown up in Linux-next yet.
> Is this branch supposed to be part of -next?

Yes, I will update my next branch with these changes.

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

