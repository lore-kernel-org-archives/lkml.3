Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab3E0O1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:27:20 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:32998 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054Ab3E0O1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:27:18 -0400
Message-ID: <51A36D42.6080609@linaro.org>
Date: Mon, 27 May 2013 16:27:14 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] clocksource: dw_apb: fix error check
References: <90d7cc35674bf04806531eb2e9836fdc382868d9.1369655478.git.baruch@tkos.co.il> <51A35C2F.4000201@linaro.org> <20130527134910.GU5037@tarshish>
In-Reply-To: <20130527134910.GU5037@tarshish>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 03:49 PM, Baruch Siach wrote:
> Hi Daniel,
> 
> On Mon, May 27, 2013 at 03:14:23PM +0200, Daniel Lezcano wrote:
>> On 05/27/2013 01:51 PM, Baruch Siach wrote:
>>> irq_of_parse_and_map() returns 0 on error, while the code checks for NO_IRQ.
>>> This breaks on platforms that have NO_IRQ != 0.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>>> ---
>>
>> Shouldn't the 'irq_of_parse_and_map' function to be fixed and return
>> NO_IRQ in case of error ? (even if some code checks the return value is
>> 'zero' in case of error [1], while some other code checks NO_IRQ [2]).
> 
> Probably not. See http://lwn.net/Articles/470820/.

Very interesting. Thx for the pointer !

  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

