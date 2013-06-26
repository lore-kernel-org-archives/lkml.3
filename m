Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3FZWRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:17:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48170 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3FZWRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:17:37 -0400
Date: Wed, 26 Jun 2013 15:17:36 -0700 (PDT)
Message-Id: <20130626.151736.1797290996825764087.davem@davemloft.net>
To: bootc@bootc.net
Cc: timo.teras@iki.fi, fan.du@windriver.com, sakiwit@gmail.com,
        steffen.klassert@secunet.com, herbert@gondor.hengli.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PANIC at net/xfrm/xfrm_output.c:125 (3.9.4)
From: David Miller <davem@davemloft.net>
In-Reply-To: <51C367DC.8050808@bootc.net>
References: <51B03EAC.6080508@bootc.net>
	<20130606113840.511a72c3@vostro>
	<51C367DC.8050808@bootc.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Boot <bootc@bootc.net>
Date: Thu, 20 Jun 2013 21:36:44 +0100

> On 06/06/2013 09:38, Timo Teras wrote:
>> On Thu, 06 Jun 2013 08:47:56 +0100
>> Chris Boot <bootc@bootc.net> wrote:
>> 
>>> On 06/06/13 02:24, Fan Du wrote:
>>>> Hello Chris/Jean
>>>>
>>>> This issue might have already been fixed by this:
>>>> https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/net/xfrm/xfrm_output.c?id=497574c72c9922cf20c12aed15313c389f722fa0
>>>>
>>>>
>>>> Hope it helps.
>>>
>>> Hi Fan, Jean,
>>>
>>> Thanks, that looks like it's the patch for exactly my problem.
>>> Unfortunately I can't test it until next week now. :-/
>>>
>>> Timo/Dave: are there any plans to push this into 3.10-rc and/or
>>> stable? I seem to be able to hit the issue pretty reliably.
>> 
>> It is already present in 3.10-rc3 [1], and Dave has it queued for
>> 3.9-stable [2].
>> 
>> - Timo
>> 
>> [1] http://lwn.net/Articles/551922/
>> [2] http://patchwork.ozlabs.org/patch/245594/
> 
> I'm just wondering if this patch has got lost in the cracks; I reported
> the issue in 3.9.4 and 3.9.7 is just out without any sign of it. Have I
> missed something?

It got submitted to -stable last week.
