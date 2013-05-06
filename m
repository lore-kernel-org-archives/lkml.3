Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab3EFI7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 04:59:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:54672 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab3EFI7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 04:59:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,620,1363158000"; 
   d="scan'208";a="329446154"
Message-ID: <518770D0.50508@intel.com>
Date: Mon, 06 May 2013 16:58:56 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
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
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 1/7] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
 dependency for load-tracking"
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-2-git-send-email-alex.shi@intel.com> <CAPM31R+4Ar5FFGSgfts76qNiQ5GMpPk7wkuj1fwsFrugVwnLfQ@mail.gmail.com> <51876E92.3010300@intel.com> <CAPM31RLOHcDGJy6bpXeMN90+NpGNkKS=32Wyq5r0LkdGb=SKkQ@mail.gmail.com>
In-Reply-To: <CAPM31RLOHcDGJy6bpXeMN90+NpGNkKS=32Wyq5r0LkdGb=SKkQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 04:55 PM, Paul Turner wrote:
>> > Is the comments ok? :)
>> >
>> > /* runnable related variables only used in FAIR_GROUP_SCHED */
> Perhaps:
> 
>  -/* These always depend on CONFIG_FAIR_GROUP_SCHED */
> #ifdef ...
> +/* Required to track per-cpu representation of a task_group */
> 
> 

looks fine. thanks a lot!

-- 
Thanks
    Alex
