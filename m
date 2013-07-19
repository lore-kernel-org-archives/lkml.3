Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118Ab3GSL1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 07:27:06 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:45383 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3GSL1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 07:27:03 -0400
Message-ID: <51E921EC.5040501@linux.vnet.ibm.com>
Date: Fri, 19 Jul 2013 16:54:28 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [RFC PATCH v2] sched: Limit idle_balance()
References: <1374220211.5447.9.camel@j-VirtualBox>
In-Reply-To: <1374220211.5447.9.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071911-1618-0000-0000-0000044D4B24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Json,

I ran ebizzy and kernbench benchmarks on your 3.11-rc1 + your        "V1
patch" on a 1 socket, 16 core powerpc machine. I thought I would let you
know the results before I try your V2.

Ebizzy: 30 seconds run. The table below shows the improvement in the
number of records completed. I have not spent enough time on the patch
to explain such a big improvement.

Number_of_threads   %improvement_with_patch
    4                          41.86%
    8                          9.8%
   12                          34.77%
   16                          28.37%

While on kernbench there was no significant change in the observation.

I will try patch V2 and let you know the results.

Regards
Preeti U Murthy

