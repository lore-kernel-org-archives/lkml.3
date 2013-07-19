Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab3GST2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:28:14 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:47359 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3GST2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:28:12 -0400
Message-ID: <1374262090.1830.16.camel@j-VirtualBox>
Subject: Re: [RFC PATCH v2] sched: Limit idle_balance()
From: Jason Low <jason.low2@hp.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Fri, 19 Jul 2013 12:28:10 -0700
In-Reply-To: <51E921EC.5040501@linux.vnet.ibm.com>
References: <1374220211.5447.9.camel@j-VirtualBox>
	 <51E921EC.5040501@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 16:54 +0530, Preeti U Murthy wrote:
> Hi Json,
> 
> I ran ebizzy and kernbench benchmarks on your 3.11-rc1 + your        "V1
> patch" on a 1 socket, 16 core powerpc machine. I thought I would let you
> know the results before I try your V2.
> 
> Ebizzy: 30 seconds run. The table below shows the improvement in the
> number of records completed. I have not spent enough time on the patch
> to explain such a big improvement.
> 
> Number_of_threads   %improvement_with_patch
>     4                          41.86%
>     8                          9.8%
>    12                          34.77%
>    16                          28.37%
> 
> While on kernbench there was no significant change in the observation.
> 
> I will try patch V2 and let you know the results.

Great to see those improvements so far. Thank you for testing this.

Jason

