Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaBJBhI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:37:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21925 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaBJBhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:37:06 -0500
Message-ID: <52F82D0F.2000300@oracle.com>
Date: Sun, 09 Feb 2014 20:36:15 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "Ira W. Snyder" <iws@ovro.caltech.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] liblockdep fixes for v3.14
References: <52F2C56F.5030309@oracle.com> <20140209125325.GA23318@gmail.com>
In-Reply-To: <20140209125325.GA23318@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 07:53 AM, Ingo Molnar wrote:
>
> * Sasha Levin <sasha.levin@oracle.com> wrote:
>
>> The following changes since commit 65370bdf881e20907e7a53abab9b8c0bc5f60a6b:
>>
>>    Merge branch 'linus' into core/locking (2014-02-02 09:43:20 +0100)
>>
>> are available in the git repository at:
>>
>>
>>    https://github.com/sashalevin/liblockdep.git liblockdep-fixes
>>
>> for you to fetch changes up to a521b55af18ac72c969c1ba41b660d77dae37357:
>>
>>    liblockdep: add a stub for new rcu_is_watching (2014-02-05 18:03:54 -0500)
>>
>> ----------------------------------------------------------------
>> Ira W. Snyder (3):
>>        tools: lockdep: fix initialization code path
>>        tools: lockdep: fix include of asm/hash.h
>>        tools: lockdep: add include directory to allow tests to compile
>>
>> Sasha Levin (2):
>>        liblockdep: mark runtests.sh as executable
>>        liblockdep: add a stub for new rcu_is_watching
>
> So I have a couple of nits about the commits:
>
> 1)
>
> Please use the following standard tags/prefixes:
>
>     tools/liblockdep: Fix initialization code path
>     ...
>
> and also capitalize sentences properly.
>
> 2)
>
> Faulty SOB sequences:
>
>   Author: Ira W. Snyder <iws@ovro.caltech.edu>
>   Date:   Fri Jan 31 13:35:32 2014 -0800
>
>      tools: lockdep: add include directory to allow tests to compile
>
>      Acked-by: Sasha Levin <sasha.levin@oracle.com>
>      Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
>
>
> That's not how we do signoffs, maintainer commits should be:
>
> 	Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> 	Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>
>
> As a side note, that's not a valid Ack sequence either, which if done
> should be the other way around:
>
>      Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
>      Acked-by: Sasha Levin <sasha.levin@oracle.com>
>
> 3)
>
> It's not clear which patch you are referring to here:
>
>      This patch mirrors the fix used for perf, titled "tools: perf:
>      util: fix include for non x86 architectures".
>
> It's neither in the series, nor in upstream.

Thanks for the review Ingo, this was my first time doing a pull request. I'll fix everything and resend.

About 3, Arnaldo pulled that patch into -tip a week ago (https://lkml.org/lkml/2014/2/2/34).


Thanks,
Sasha

