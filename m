Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbbA0JFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 04:05:20 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:44976 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbbA0JFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 04:05:13 -0500
Message-ID: <54C754C6.8090502@linaro.org>
Date: Tue, 27 Jan 2015 10:05:10 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Subject: Re: [PATCH] ARM: clocksource: fix compile of asm9260_timer driver
 on ARCH=parisc
References: <54BE5E9A.8070502@linaro.org> <1422343624-9764-1-git-send-email-linux@rempel-privat.de> <54C75126.5070905@linaro.org> <54C75184.7030507@rempel-privat.de>
In-Reply-To: <54C75184.7030507@rempel-privat.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2015 09:51 AM, Oleksij Rempel wrote:
> Am 27.01.2015 um 09:49 schrieb Daniel Lezcano:
>> On 01/27/2015 08:27 AM, Oleksij Rempel wrote:
>>> make sure this driver depends on GENERIC_CLOCKEVENTS
>>>
>>> compiler error was found by kbuild test robot:
>>>
>>>>> drivers/clocksource/asm9260_timer.c:114:14: warning: its scope is
>>>>> only this definition or declaration, which is probably not what you
>>>>> want
>>>>> drivers/clocksource/asm9260_timer.c:124:16: warning: 'struct
>>>>> clock_event_device' declared inside parameter list
>>>               struct clock_event_device *evt)
>>>
>>>>> drivers/clocksource/asm9260_timer.c:124:16: warning: 'enum
>>>>> clock_event_mode' declared inside parameter list
>>>>> drivers/clocksource/asm9260_timer.c:123:58: error: parameter 1
>>>>> ('mode') has incomplete type
>>>       static void asm9260_timer_set_mode(enum clock_event_mode mode,
>>>
>>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>>
>> I would like to fold this patch with the asm9260 timer patch in order to
>> prevent git bisecting breakage. Ok for you ?
>
> Ok, no problem.

Done.

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

