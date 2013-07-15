Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3GOFOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 01:14:18 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:49496 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab3GOFOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 01:14:16 -0400
Message-ID: <51E38517.5040300@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 13:13:59 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: smart wake-affine
References: <51D29EE5.8080307@linux.vnet.ibm.com> <20130704091339.GK18898@dyad.programming.kicks-ass.net> <51D5428D.7080805@linux.vnet.ibm.com> <1372934013.9046.16.camel@marge.simpson.net> <51D633DB.5010508@linux.vnet.ibm.com> <1372997318.7315.23.camel@marge.simpson.net> <51D64C84.5080100@linux.vnet.ibm.com> <1373002865.8318.11.camel@marge.simpson.net> <51D664B9.7010407@linux.vnet.ibm.com> <1373179405.19316.41.camel@marge.simpson.net> <20130708082106.GW23916@twins.programming.kicks-ass.net> <1373309998.1744.3.camel@buesod1.americas.hpqcorp.net> <51DB75D4.6050302@linux.vnet.ibm.com> <1373337407.1744.20.camel@buesod1.americas.hpqcorp.net> <51DB7AF7.50708@linux.vnet.ibm.com>
In-Reply-To: <51DB7AF7.50708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071505-6102-0000-0000-000003DACA2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Davidlohr

On 07/09/2013 10:52 AM, Michael Wang wrote:
> On 07/09/2013 10:36 AM, Davidlohr Bueso wrote:
> [snip]
>>> 2. is the 3.10-rc5 in image also disabled the hyperthreading?
>>
>> Yes, I happened to have data already collected for 3.10-rc5. While the
>> runs with this patch was with -rc7, unless there was some performance
>> related commit I missed, I don't think the performance difference was
>> because of that.
>>
>>> 3. is the v3 patch set show the same issue?
>>
>> Uhmmm shoot, I didn't realize there was a v3, sorry about that.
>>
>> /me takes another look at the thread.
> 
> V3 will reduce the overhead, should make things better, especially when
> workload is high and platform is big (your box is really what I desired
> ;-), honestly).
> 
> And if it is possible, comparison based on the same basement will be
> better :)

I have done some tests with reaim high_systime workfile, and I could not
find regression on my box (the tool itself has some issue, but I got the
results), v3 works well.

I suppose the issue have been addressed, but please let us know if v3
also show regression on your box, we could try to solve the problem ;-)

Regards,
Michael Wang

> 
> Regards,
> Michael Wang
> 
>>
>> Thanks,
>> Davidlohr
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

