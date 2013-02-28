Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab3B1Itj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:49:39 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:47120 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3B1Itg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:49:36 -0500
Message-ID: <512F1A15.2000609@linux.vnet.ibm.com>
Date: Thu, 28 Feb 2013 16:49:25 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH] sched: wakeup buddy
References: <512EFB4B.5040204@linux.vnet.ibm.com> <1362035917.4460.105.camel@marge.simpson.net> <512F09D4.1020307@linux.vnet.ibm.com> <1362038652.4460.124.camel@marge.simpson.net> <512F11E6.8060807@linux.vnet.ibm.com> <1362039862.4460.132.camel@marge.simpson.net>
In-Reply-To: <1362039862.4460.132.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022808-9574-0000-0000-000006C8BB94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 04:24 PM, Mike Galbraith wrote:
> On Thu, 2013-02-28 at 16:14 +0800, Michael Wang wrote: 
>> On 02/28/2013 04:04 PM, Mike Galbraith wrote:
> 
>>> It would be nice if it _were_ a promise, but it is not, it's a hint.
>>
>> Bad to know :(
>>
>> Should we fix it or this is by designed? The comments after WF_SYNC
>> cheated me...
> 
> You can't fix it, because it's not busted.  You can say "Ok guys, I'm
> off for a nap RSN" all you want, but that won't guarantee that nobody
> pokes you, and hands you something more useful to do than snoozing.

So sync still means current is going to sleep, what you concerned is
this promise will be easily broken by other waker, correct?

Hmm.. may be you are right, if 'perf bench sched pipe' is not the one we
should care, I have no reason to add this logical currently.

I will remove this plus branch, unless I found other benchmark could
benefit a lot from it.

Besides this, how do you think about this idea?

Regards,
Michael Wang

> 
> -Mike  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

