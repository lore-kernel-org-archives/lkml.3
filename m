Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaBXDYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:24:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39740 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaBXDYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:24:21 -0500
Message-ID: <530ABB44.5000601@oracle.com>
Date: Sun, 23 Feb 2014 22:23:48 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michael wang <wangyun@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
References: <5304F32A.4040907@oracle.com> <5305856F.3000109@linux.vnet.ibm.com> <53078241.3060201@oracle.com> <53080122.609@linux.vnet.ibm.com>
In-Reply-To: <53080122.609@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 08:45 PM, Michael wang wrote:
> On 02/22/2014 12:43 AM, Sasha Levin wrote:
>> On 02/19/2014 11:32 PM, Michael wang wrote:
>>> On 02/20/2014 02:08 AM, Sasha Levin wrote:
>>>>> Hi all,
>>>>>
>>>>> While fuzzing with trinity inside a KVM tools guest, running latest
>>>>> -next kernel, I see to hit the following hang quite often.
>>> Fix for the stuck issue around idle_balance() is now in progress, this
>>> may caused be the same problem, I suggest we do some retest after these
>>> patch got merged.
>>
>> Could I get a link to the patch please? It's a pain testing other things
>> with this issue reproducing every time.
>
> Please take a try on the latest tip tree, patches has been merged as I
> saw :)

Nope, still see it with latest -tip.

I ran tip's master branch, should I have tried a different one?


Thanks,
sasha

