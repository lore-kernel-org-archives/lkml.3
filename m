Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab3FQNX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:23:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:49494 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256Ab3FQNX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:23:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,881,1363158000"; 
   d="scan'208";a="354887486"
Message-ID: <51BF0DE2.1070806@intel.com>
Date: Mon, 17 Jun 2013 21:23:46 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [patch v8 3/9] sched: set initial value of runnable avg for new
 forked task
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-4-git-send-email-alex.shi@intel.com> <CAPM31RJFsh_gBXBHc4E6z=MtORR9D8sWs=86Yqy9onxK9x9fOg@mail.gmail.com> <51BB25BC.9070500@intel.com> <20130617092146.GM3204@twins.programming.kicks-ass.net> <51BEDD9E.600@intel.com> <20130617130738.GW3204@twins.programming.kicks-ass.net>
In-Reply-To: <20130617130738.GW3204@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Example:
> 
> From: PJT
> 
> foo patch implements foo because bar; note the fubar detail.
> 
> SoB: PJT
> [alex@intel: changed ponies into horses to make it fit]
> SoB: Alex
> 
> The other case is where a 'simple' modification of the initial patch
> simply won't do; you need to change the core idea of the patch or
> similar. In this case I've seen things like:
> 
> From: Alex
> 
> foo patch implements foo because bar; note the fubar detail.
> 
> Based-on-patch-by: PJT
> SoB: Alex
> 
> 
> This isn't actually in the submitting patches document and I'm not sure
> it should be; although some clarification for these weird cases might be
> useful.

It is very very useful clarification!

Currently even some maintainers do not use the 'From' and SoB correctly.
So I do suggest including it into Documentation/SubmittingPatches files.
That will help everyone! :)

-- 
Thanks
    Alex
