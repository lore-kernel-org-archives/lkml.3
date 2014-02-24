Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaBXFTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:19:24 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:42779 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaBXFTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:19:23 -0500
Message-ID: <530AD653.3000808@linux.vnet.ibm.com>
Date: Mon, 24 Feb 2014 13:19:15 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
References: <5304F32A.4040907@oracle.com> <5305856F.3000109@linux.vnet.ibm.com> <53078241.3060201@oracle.com> <53080122.609@linux.vnet.ibm.com> <530ABB44.5000601@oracle.com>
In-Reply-To: <530ABB44.5000601@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022405-8878-0000-0000-00000B038F69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 11:23 AM, Sasha Levin wrote:
[snip]
>>>
>>> Could I get a link to the patch please? It's a pain testing other things
>>> with this issue reproducing every time.
>>
>> Please take a try on the latest tip tree, patches has been merged as I
>> saw :)
> 
> Nope, still see it with latest -tip.
> 
> I ran tip's master branch, should I have tried a different one?

Hmm... I don't see the changes we expected on master either...

Peter, do we accidentally missed this commit?

http://git.kernel.org/tip/477af336ba06ef4c32e97892bb0d2027ce30f466

Regards,
Michael Wang

> 
> 
> Thanks,
> sasha
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

