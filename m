Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3CKJOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:14:43 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:47902 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab3CKJOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:14:42 -0400
Message-ID: <513DA076.80009@linux.vnet.ibm.com>
Date: Mon, 11 Mar 2013 17:14:30 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wakeup buddy
References: <5136EB06.2050905@linux.vnet.ibm.com> <1362645372.2606.11.camel@laptop> <20130311082105.GB12742@gmail.com>
In-Reply-To: <20130311082105.GB12742@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031109-7014-0000-0000-000002B2D18C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo

On 03/11/2013 04:21 PM, Ingo Molnar wrote:
[snip]
> 
> I have actually written the prctl() approach before, for instrumentation 
> purposes, and it does wonders to system analysis.

The idea sounds great, we could get many new info to implement more
smart scheduler, that's amazing :)

> 
> Any objections?

Just one concern, may be I have misunderstand you, but will it cause
trouble if the prctl() was indiscriminately used by some applications,
will we get fake data?

Regards,
Michael Wang

> 
> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

