Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3GOGBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:01:42 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:35282 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3GOGBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:01:41 -0400
Message-ID: <51E39037.6010906@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 14:01:27 +0800
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
References: <51D29EE5.8080307@linux.vnet.ibm.com> <20130704091339.GK18898@dyad.programming.kicks-ass.net> <51D5428D.7080805@linux.vnet.ibm.com> <1372934013.9046.16.camel@marge.simpson.net> <51D633DB.5010508@linux.vnet.ibm.com> <1372997318.7315.23.camel@marge.simpson.net> <51D64C84.5080100@linux.vnet.ibm.com> <1373002865.8318.11.camel@marge.simpson.net> <51D664B9.7010407@linux.vnet.ibm.com> <1373179405.19316.41.camel@marge.simpson.net> <20130708082106.GW23916@twins.programming.kicks-ass.net> <1373309998.1744.3.camel@buesod1.americas.hpqcorp.net> <51DB75D4.6050302@linux.vnet.ibm.com> <1373337407.1744.20.camel@buesod1.americas.hpqcorp.net> <51DB7AF7.50708@linux.vnet.ibm.com> <51E38517.5040300@linux.vnet.ibm.com> <1373867877.2072.2.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1373867877.2072.2.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071505-8256-0000-0000-00000856663E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 01:57 PM, Davidlohr Bueso wrote:
[snip]
>>>
>>> And if it is possible, comparison based on the same basement will be
>>> better :)
>>
>> I have done some tests with reaim high_systime workfile, and I could not
>> find regression on my box (the tool itself has some issue, but I got the
>> results), v3 works well.
> 
> Sorry for the delay. I'm glad you reminded me since I already had the
> data.
>>
>> I suppose the issue have been addressed, but please let us know if v3
>> also show regression on your box, we could try to solve the problem ;-)
> 
> It has, high_systime no longer shows a hit and all workloads remain
> basically the same.
> 
> Tested-by: Davidlohr Bueso <davidlohr.bueso@hp.com>

Thanks for the testing, I think we could go ahead now ;-)

Regards,
Michael Wang

> 
> Thanks.
> 
>>
>> Regards,
>> Michael Wang
>>
>>>
>>> Regards,
>>> Michael Wang
>>>
>>>>
>>>> Thanks,
>>>> Davidlohr
>>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

