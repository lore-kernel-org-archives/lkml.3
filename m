Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab3EGLF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 07:05:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:2209 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab3EGLFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 07:05:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,627,1363158000"; 
   d="scan'208";a="309499044"
Message-ID: <5188DFEF.6010403@intel.com>
Date: Tue, 07 May 2013 19:05:19 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 3/7] sched: set initial value of runnable avg for new
 forked task
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-4-git-send-email-alex.shi@intel.com> <CAPM31RJg7t8f1H-dZwzP1c-0HHb_=8twidX74gS2NfyQhHUhCw@mail.gmail.com> <5187760D.8060900@intel.com> <CAPM31RKiCfSZ=hJ9P7WOH6AC8uj6b06mEM6K0WCTYXC7OJAq7A@mail.gmail.com> <51886460.3020009@intel.com> <CAPM31RLsip-PMY73oq58gyi42EQ+-upmPpMQFkukVBX6LTwtCw@mail.gmail.com> <20130507095715.GE4068@e103034-lin>
In-Reply-To: <20130507095715.GE4068@e103034-lin>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 05:57 PM, Morten Rasmussen wrote:
> Agree. The tracked load of new tasks is often very unstable during first
> couple of ms on loaded systems. I'm not sure if 1024 is the right
> initial value. It may need to be larger.

Maybe Peter can give a better value according to the experience on
scheduler. :)

-- 
Thanks
    Alex
