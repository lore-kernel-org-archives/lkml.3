Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab3FCFup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 01:50:45 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:44882 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3FCFuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 01:50:39 -0400
Message-ID: <51AC2EA2.7030106@linux.vnet.ibm.com>
Date: Mon, 03 Jun 2013 13:50:26 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [RFC PATCH] sched: smart wake-affine
References: <51A43B16.9080801@linux.vnet.ibm.com> <51ABFF6A.60206@linux.vnet.ibm.com> <1370228941.5988.66.camel@marge.simpson.net> <51AC0CD4.9070302@linux.vnet.ibm.com> <1370231597.5988.79.camel@marge.simpson.net> <51AC2121.1060903@linux.vnet.ibm.com> <1370236944.5988.108.camel@marge.simpson.net>
In-Reply-To: <1370236944.5988.108.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060305-4790-0000-0000-000008981B22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 01:22 PM, Mike Galbraith wrote:
[snip]
>>
>> I agree that this idea, in other work, 'stop wake-affine when current is
>> busy with wakeup' may miss the chance to bring benefit, although I could
>> not find such workload, but I can't do promise...
> 
> Someday we'll find the perfect balance... likely the day before the sun
> turns into a red giant and melts the earth.

Won't take so long ;-)

I would like to stop the regression on pgbench firstly, as PeterZ
mentioned, if someone reported other regressions, we will know what is
missing, if fix is possible, we fix it, if cost is too high, then I say
we ignore the illegal income, after all, we could not benefit one in the
cost of sacrifice others...

I'd like to fix the problem ASAP, it's really a big, urgent problem on
my point of view, but doesn't win enough attentions as I thought it will...

The regression has been buried too long and hidden, if we miss the
chance to correct the issue this time, it will no doubt been buried again...

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

