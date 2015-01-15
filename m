Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbbAORNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:13:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:59788 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbbAORNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:13:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,404,1418112000"; 
   d="scan'208";a="512812322"
Message-ID: <1421341986.2399.23.camel@schen9-desk2.jf.intel.com>
Subject: Re: [PATCH] Repost sched-rt: Reduce rq lock contention by
 eliminating locking of non-feasible target
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Suruchi Kadu <suruchi.a.kadu@intel.com>,
        Doug Nelson <doug.nelson@intel.com>, linux-kernel@vger.kernel.org,
        Juri Lelli <juri.lelli@gmail.com>
Date: Thu, 15 Jan 2015 09:13:06 -0800
In-Reply-To: <20150106193025.GD23965@worktop.programming.kicks-ass.net>
References: <1420570911.2399.4.camel@schen9-desk2.jf.intel.com>
	 <20150106193025.GD23965@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-06 at 20:30 +0100, Peter Zijlstra wrote:
> On Tue, Jan 06, 2015 at 11:01:51AM -0800, Tim Chen wrote:
> > Didn't get any response for this patch probably due to the holidays.
> > Reposting it as we will like to get it merged to help our database
> > workload.
> > 
> > This patch added checks that prevent futile attempts to move rt tasks
> > to cpu with active tasks of equal or higher priority.  This reduces
> > run queue lock contention and improves the performance of a well
> > known OLTP benchmark by 0.7%.
> 
> Don't immediately see anything wrong with this, Steve?

Steve, do you have any objections to this patch?  Thanks.

Tim


