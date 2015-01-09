Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbbAIVzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:55:54 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbbAIVzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:55:52 -0500
Message-ID: <54B04E65.60306@nod.at>
Date: Fri, 09 Jan 2015 22:55:49 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Fastmap update v2 (pile 1)
References: <1416835236-25185-1-git-send-email-richard@nod.at> <54B04A50.8040307@vanguardiasur.com.ar>
In-Reply-To: <54B04A50.8040307@vanguardiasur.com.ar>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.01.2015 um 22:38 schrieb Ezequiel Garcia:
> Hi Richard,
> 
> On 11/24/2014 10:20 AM, Richard Weinberger wrote:
>> Artem,
>>
>> as requested I'm resending my fastmap work in smaller pieces.
>> This is pile 1 of 7.
>> Rebasing my patches to ubifs.git was a massive PITA because the
>> logging style changes touched a lot of code and almost every patch
>> failed to apply and needed inspection by hand.
>> The first patches are bug fixes, the latter introduce cleanups
>> and new features.
>> After all bugfixes are mainline I'll make sure that all needed
>> fixes go into -stable.
>>
> 
> Maybe it would be clearer if you could point out exactly which of these
> are considered bugfixes.

All of Pile1, 2, 3 and 4. :-)
One or tow patches are preparations for the real fix but obviously you'll need them
too.
The rest are enhancements and cleanups.
As I wrote before I've structured the patch set in a way to make backporting easy.

> For bugfixes, having a detailed explanation of the problem the commit is
> meant to fix would be better as well.

Okay, I'll add the horror stories to these patches.

> This patchset seems to have stalled, so perhaps having this information
> would help Artem to pick the ones that you point as fixes, before we
> miss another cycle.

The question is, shall I wait for Artem or resend again?
Most patches are completely unseen.

> Would it help if we test the whole series? (any specific test in mind?)

Sure. All issues have been found while real world usage and excessive powercut tests.

Thanks,
//richard
