Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbbAVEZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 23:25:10 -0500
Received: from mga03.intel.com ([134.134.136.65]:30826 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbbAVEZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:25:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,446,1418112000"; 
   d="scan'208";a="654639096"
Date: Thu, 22 Jan 2015 12:05:32 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, riel@redhat.com, jason.low2@hp.com,
        fweisbec@gmail.com, Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v6 5/7] sched/fair: fix idle balance when remaining tasks
 are all non-CFS tasks
Message-ID: <20150122040532.GA5426@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
 <1416962647-76792-6-git-send-email-wanpeng.li@linux.intel.com>
 <20150119124528.GO25256@twins.programming.kicks-ass.net>
 <20150119231837.GB3687@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119231837.GB3687@kernel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 07:18:37AM +0800, Wanpeng Li wrote:
>>>  		if (!rq->rd->overload)
>>>  			rq->rd->overload = true;
>>
>>Here 3882ec643997 ("nohz: Use IPI implicit full barrier against
>>rq->nr_running r/w") might be a clue.
>>
>>Also, this is wrong, it breaks NOHZ_FULL.
>
>Got it. If the modification in update_sg_lb_stats of my patch is still
>corrrect, if so I can send out a new version.

Ping,

>
>Regards,
>Wanpeng Li 
