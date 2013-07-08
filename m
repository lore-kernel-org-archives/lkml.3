Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3GHJIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:08:55 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:50199 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3GHJIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:08:54 -0400
Message-ID: <51DA8191.3030202@linux.vnet.ibm.com>
Date: Mon, 08 Jul 2013 17:08:33 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: smart wake-affine
References: <51D29EE5.8080307@linux.vnet.ibm.com> <20130704091339.GK18898@dyad.programming.kicks-ass.net> <51D5428D.7080805@linux.vnet.ibm.com> <1372934013.9046.16.camel@marge.simpson.net> <51D633DB.5010508@linux.vnet.ibm.com> <1372997318.7315.23.camel@marge.simpson.net> <51D64C84.5080100@linux.vnet.ibm.com> <1373002865.8318.11.camel@marge.simpson.net> <51D664B9.7010407@linux.vnet.ibm.com> <1373179405.19316.41.camel@marge.simpson.net> <20130708082106.GW23916@twins.programming.kicks-ass.net> <1373273368.30325.7.camel@marge.simpson.net>
In-Reply-To: <1373273368.30325.7.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070809-5816-0000-0000-000008CF1832
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 04:49 PM, Mike Galbraith wrote:
> On Mon, 2013-07-08 at 10:21 +0200, Peter Zijlstra wrote: 
>> On Sun, Jul 07, 2013 at 08:43:25AM +0200, Mike Galbraith wrote:
>>> On Fri, 2013-07-05 at 14:16 +0800, Michael Wang wrote:
>>>
>>>> PeterZ has suggested some optimization which I sent out yesterday, I
>>>> suppose they haven't been included into this test yet, correct?
>>>
>>> No, that was with both v3 patches applied.  hackbench -l 1000 delta
>>> tracked to next pull/build fwiw, but I don't see anything noteworthy
>>> elsewhere, so I'm filing it under "tasks/core ~= zillion ~= hohum".
>>
>> OK, I'll apply the patches, we'll see what happens. If there significant
>> fallout we'll immediately have more information anyway ;-)
> 
> Yup.  It's a repeatable oddity on my box, but it doesn't even track to
> itself when using different hackbench parameters.  All I can really
> conclude from test results is "golly, changing stuff affects stuff" :) 

If there is problems, they will show up sooner or later, and we just
conquer them at that time ;-)

And thanks again for all the help you've done :)

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

