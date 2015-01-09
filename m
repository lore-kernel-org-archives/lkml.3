Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbbAIWMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:12:03 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61553 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbAIWMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:12:01 -0500
Message-ID: <54B051B3.3050308@vanguardiasur.com.ar>
Date: Fri, 09 Jan 2015 19:09:55 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Organization: VanguardiaSur
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Fastmap update v2 (pile 1)
References: <1416835236-25185-1-git-send-email-richard@nod.at> <54B04A50.8040307@vanguardiasur.com.ar> <54B04E65.60306@nod.at>
In-Reply-To: <54B04E65.60306@nod.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/09/2015 06:55 PM, Richard Weinberger wrote:
> Am 09.01.2015 um 22:38 schrieb Ezequiel Garcia:
>> Hi Richard,
>>
>> On 11/24/2014 10:20 AM, Richard Weinberger wrote:
>>> Artem,
>>>
>>> as requested I'm resending my fastmap work in smaller pieces.
>>> This is pile 1 of 7.
>>> Rebasing my patches to ubifs.git was a massive PITA because the
>>> logging style changes touched a lot of code and almost every patch
>>> failed to apply and needed inspection by hand.
>>> The first patches are bug fixes, the latter introduce cleanups
>>> and new features.
>>> After all bugfixes are mainline I'll make sure that all needed
>>> fixes go into -stable.
>>>
>>
>> Maybe it would be clearer if you could point out exactly which of these
>> are considered bugfixes.
> 
> All of Pile1, 2, 3 and 4. :-)
> One or tow patches are preparations for the real fix but obviously you'll need them
> too.
> The rest are enhancements and cleanups.

What do you mean by "the rest"?

> As I wrote before I've structured the patch set in a way to make backporting easy.
> 
>> For bugfixes, having a detailed explanation of the problem the commit is
>> meant to fix would be better as well.
> 
> Okay, I'll add the horror stories to these patches.
> 

I know it's a real pain, but if you can add a Fixes: tag, it would
certainly help Artem track down the bug. The good thing is that you get
the -stable hassle for free.

>> This patchset seems to have stalled, so perhaps having this information
>> would help Artem to pick the ones that you point as fixes, before we
>> miss another cycle.
> 
> The question is, shall I wait for Artem or resend again?

Hm, well, given we are just a handful of developers, and we are all time
constrained, maybe we could focus on the first two piles for now:

Pile 1, November 24, https://lkml.org/lkml/2014/11/24/324
Pile 2, November 30, https://lkml.org/lkml/2014/11/30/50

> Most patches are completely unseen.
>

Well, those two piles look reviewed and tested to me.
-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
