Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3F0WH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 18:07:58 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:55230 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3F0WH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 18:07:57 -0400
Message-ID: <51CCB7B6.10504@bootc.net>
Date: Thu, 27 Jun 2013 23:07:50 +0100
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: timo.teras@iki.fi, fan.du@windriver.com, sakiwit@gmail.com,
        steffen.klassert@secunet.com, herbert@gondor.hengli.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PANIC at net/xfrm/xfrm_output.c:125 (3.9.4)
References: <51B03EAC.6080508@bootc.net> <20130606113840.511a72c3@vostro> <51C367DC.8050808@bootc.net> <20130626.151736.1797290996825764087.davem@davemloft.net>
In-Reply-To: <20130626.151736.1797290996825764087.davem@davemloft.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/2013 23:17, David Miller wrote:
> From: Chris Boot <bootc@bootc.net>
> Date: Thu, 20 Jun 2013 21:36:44 +0100
> 
>> On 06/06/2013 09:38, Timo Teras wrote:
>>> On Thu, 06 Jun 2013 08:47:56 +0100
>>> Chris Boot <bootc@bootc.net> wrote:
>>> 
>>>> On 06/06/13 02:24, Fan Du wrote:
>>>>> Hello Chris/Jean
>>>>>
>>>>> This issue might have already been fixed by this:
>>>>> https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/net/xfrm/xfrm_output.c?id=497574c72c9922cf20c12aed15313c389f722fa0
>>>>>
>>>>>
>>>>> Hope it helps.
>>>>
>>>> Hi Fan, Jean,
>>>>
>>>> Thanks, that looks like it's the patch for exactly my problem.
>>>> Unfortunately I can't test it until next week now. :-/
>>>>
>>>> Timo/Dave: are there any plans to push this into 3.10-rc and/or
>>>> stable? I seem to be able to hit the issue pretty reliably.
>>> 
>>> It is already present in 3.10-rc3 [1], and Dave has it queued for
>>> 3.9-stable [2].
>>> 
>>> - Timo
>>> 
>>> [1] http://lwn.net/Articles/551922/
>>> [2] http://patchwork.ozlabs.org/patch/245594/
>> 
>> I'm just wondering if this patch has got lost in the cracks; I reported
>> the issue in 3.9.4 and 3.9.7 is just out without any sign of it. Have I
>> missed something?
> 
> It got submitted to -stable last week.

Dave,

Thank you, I see it's in 3.9.8 that has been just released.

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net
