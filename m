Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbbAVSPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:15:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:50221 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbbAVSP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:15:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,450,1418112000"; 
   d="scan'208";a="516157925"
Message-ID: <1421950431.2399.44.camel@schen9-desk2.jf.intel.com>
Subject: Re: [PATCH v6 5/7] sched/fair: fix idle balance when remaining
 tasks are all non-CFS tasks
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, riel@redhat.com, jason.low2@hp.com,
        fweisbec@gmail.com
Date: Thu, 22 Jan 2015 10:13:51 -0800
In-Reply-To: <20150122040532.GA5426@kernel>
References: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
	 <1416962647-76792-6-git-send-email-wanpeng.li@linux.intel.com>
	 <20150119124528.GO25256@twins.programming.kicks-ass.net>
	 <20150119231837.GB3687@kernel> <20150122040532.GA5426@kernel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-22 at 12:05 +0800, Wanpeng Li wrote:
> On Tue, Jan 20, 2015 at 07:18:37AM +0800, Wanpeng Li wrote:
> >>>  		if (!rq->rd->overload)
> >>>  			rq->rd->overload = true;
> >>
> >>Here 3882ec643997 ("nohz: Use IPI implicit full barrier against
> >>rq->nr_running r/w") might be a clue.
> >>
> >>Also, this is wrong, it breaks NOHZ_FULL.
> >
> >Got it. If the modification in update_sg_lb_stats of my patch is still
> >corrrect, if so I can send out a new version.
> 
> Ping,
> 

Hard to respond without seeing your new patch.

Tim

> >
> >Regards,
> >Wanpeng Li 


