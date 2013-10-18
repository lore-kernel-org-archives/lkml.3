Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab3JRNnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:43:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:31857 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab3JRNnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:43:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,522,1378882800"; 
   d="scan'208";a="376648919"
Message-ID: <52613B0B.4050000@linux.intel.com>
Date: Fri, 18 Oct 2013 06:43:39 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>, "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 4/7] sched: power: Remove power capacity hints for
 kworker threads
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com> <1381511957-29776-5-git-send-email-morten.rasmussen@arm.com> <20131014133356.GN3081@twins.programming.kicks-ass.net> <525C0A51.2080407@linux.intel.com> <20131017164038.GV31039@e103034-lin> <20131017165416.GW10651@twins.programming.kicks-ass.net> <52601BEE.5090500@linux.intel.com> <20131018084737.GX31039@e103034-lin>
In-Reply-To: <20131018084737.GX31039@e103034-lin>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> We should be able to boil it down to a sequence on ARM as well. But it
> means dropping cpufreq and looking at the clock framework.
>
> Are you still using the pre- and post-change notifiers on Intel, or can
> they be ignored safely?

we do not use change notifiers
(since the hardware changes frequency independently of what "p state" we asked for
frequently and in many very common conditions, even if anything depended on being notified on changes...
it couldn't possibly work anyway)


