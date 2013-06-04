Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3FDE4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 00:56:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:51151 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab3FDE4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 00:56:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,797,1363158000"; 
   d="scan'208";a="344368759"
Message-ID: <51AD735A.2080108@intel.com>
Date: Tue, 04 Jun 2013 12:55:54 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [DISCUSSION] removing variety rq->cpu_load ?
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-6-git-send-email-alex.shi@intel.com> <CAPM31RLJe19FH+RYipwm4kwtzmFHoS2xGTx4iZ9+qwDJZ_pf3A@mail.gmail.com> <20130506101936.GE13861@dyad.programming.kicks-ass.net> <CAPM31RJg87C0nO_tAaOGLaDCUAB+QmfV4LkNcwnk9j9voNocfg@mail.gmail.com> <20130506111041.GA15446@dyad.programming.kicks-ass.net> <51889C8A.5000806@intel.com> <51AD46CA.9020609@intel.com> <51AD4808.6020507@intel.com> <51AD51E3.6060307@linux.vnet.ibm.com> <51AD549A.9010903@intel.com> <51AD5A51.1000808@linux.vnet.ibm.com>
In-Reply-To: <51AD5A51.1000808@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> >> Forgive me but I'm a little lost on this thread...
>>> >>
>>> >> So we are planing to rely on instant 'cpu_load[0]' and decayed
>>> >> 'runnable_load_avg' only, do we?
>> > 
>> > cpu_load is a kind of time decay for cpu load, but after runnable load introduced, 
>> > the decay functionality is a kind duplicate with it.
>> > So, remove them will make code simple. The idea were mentioned by Paul, Peter and I.
> Nice, what about make a patch 9 and clean up all those stuff?
> 
> I suppose we will get more benefit :)

I'd like to.

But since Peter doesn't response this thread for long time, I even don't
know what's he opinions of patch 1~8. :(

-- 
Thanks
    Alex
