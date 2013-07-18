Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab3GRCPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 22:15:33 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52306 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab3GRCPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 22:15:32 -0400
Message-ID: <51E74FB6.3060900@linux.vnet.ibm.com>
Date: Thu, 18 Jul 2013 10:15:18 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>, Mike Galbraith <efault@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: smart wake-affine
References: <51D29EE5.8080307@linux.vnet.ibm.com> <20130704091339.GK18898@dyad.programming.kicks-ass.net> <51D5428D.7080805@linux.vnet.ibm.com> <1372934013.9046.16.camel@marge.simpson.net> <51D633DB.5010508@linux.vnet.ibm.com> <1372997318.7315.23.camel@marge.simpson.net> <51D64C84.5080100@linux.vnet.ibm.com> <1373002865.8318.11.camel@marge.simpson.net> <51D664B9.7010407@linux.vnet.ibm.com> <1373179405.19316.41.camel@marge.simpson.net> <20130708082106.GW23916@twins.programming.kicks-ass.net> <1373309998.1744.3.camel@buesod1.americas.hpqcorp.net> <51DB75D4.6050302@linux.vnet.ibm.com> <1373337407.1744.20.camel@buesod1.americas.hpqcorp.net> <51DB7AF7.50708@linux.vnet.ibm.com> <51E38517.5040300@linux.vnet.ibm.com> <1373867877.2072.2.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1373867877.2072.2.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071802-7014-0000-0000-00000355FE5C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter

Davidlohr has tested the v3 patch set and it work well as reported (and
in my test too), I thing your patch has solved the issue he found in v2 :)

Thus I think v3 is ready for next step now, I wish it has not yet been
removed out of your apply-queue ;-)

Regards,
Michael Wang

On 07/15/2013 01:57 PM, Davidlohr Bueso wrote:
[snip]
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

