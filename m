Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaBXFzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:55:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44738 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaBXFzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:55:18 -0500
Message-ID: <530ADEA4.3000408@oracle.com>
Date: Mon, 24 Feb 2014 00:54:44 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michael wang <wangyun@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
References: <5304F32A.4040907@oracle.com> <5305856F.3000109@linux.vnet.ibm.com> <53078241.3060201@oracle.com> <53080122.609@linux.vnet.ibm.com> <530ABB44.5000601@oracle.com> <530AD653.3000808@linux.vnet.ibm.com>
In-Reply-To: <530AD653.3000808@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 12:19 AM, Michael wang wrote:
> On 02/24/2014 11:23 AM, Sasha Levin wrote:
> [snip]
>>>> >>>
>>>> >>>Could I get a link to the patch please? It's a pain testing other things
>>>> >>>with this issue reproducing every time.
>>> >>
>>> >>Please take a try on the latest tip tree, patches has been merged as I
>>> >>saw:)
>> >
>> >Nope, still see it with latest -tip.
>> >
>> >I ran tip's master branch, should I have tried a different one?
> Hmm... I don't see the changes we expected on master either...
>
> Peter, do we accidentally missed this commit?
>
> http://git.kernel.org/tip/477af336ba06ef4c32e97892bb0d2027ce30f466

I've tried grabbing this patch and it does pretty bad things on my testing VM, it just gets stuck 
early in the boot process and doesn't show any progress. The VM never even gets close to starting up 
all the cpus (usually dies around the lockdep self-testing).

Are there any other dependencies?


Thanks,
Sasha
