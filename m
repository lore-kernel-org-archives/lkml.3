Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab3KLSsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:48:03 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46965 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab3KLSsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:48:01 -0500
Message-ID: <528277DF.4020403@linaro.org>
Date: Tue, 12 Nov 2013 19:47:59 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents/clocksource: 3.12 fixes
References: <528234B9.7080402@linaro.org> <20131112183553.GQ14892@pengutronix.de>
In-Reply-To: <20131112183553.GQ14892@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 07:35 PM, Uwe Kleine-König wrote:
> Hello,
>
> On Tue, Nov 12, 2013 at 03:01:29PM +0100, Daniel Lezcano wrote:
>>
>> Hi Ingo and Thomas,
>>
>> this pull request has the following contain:
>>
>>   * Laurent Pinchard fixed a missing a clk_put in case the
>> registering of the sh_mtu[2] drivers fails.
>>
>>   * Uwe Kleine-König reuse clockevents_config_and_register for the
>> at91rm9200_time timer as it was depending on the patch (commit
>> a4578ea (clockevents: Sanitize ticks to nsec conversion).
>>
>> I don't know why Thomas's patch "clockevents: Sanitize ticks to nsec
>> conversion" appears in the request log because it is not part of the
>> patches interval I specified for git request pull. The diffstat does
>> not show the files which should have been changed by the patch. In
>> any case I kept the changelog untouched since it is what gives me
>> git and maybe someone can tell me why it appears.
> Look at:
>
> 	git log --oneline --graph --boundary 97b9410..42ab380
>
> Then you see that there is Thomas' patch twice. Once the version he
> committed and sent to Linus (97b9410) and once the version that you get
> as part of my pull request (a4578ea). To fix this (assuming you don't
> care much about a stable tree), simply do:
>
> 	git rebase 97b9410 42ab380
>
> and let the result pull.

Ah, yeah, I was suspecting something like that. Thanks a lot for the 
clarification.

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

