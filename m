Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3GFKsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 06:48:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40739 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3GFKsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 06:48:40 -0400
Date: Sat, 6 Jul 2013 12:47:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] sched: Reschedule task on preferred NUMA node once
 selected
Message-ID: <20130706104757.GU18898@dyad.programming.kicks-ass.net>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-7-git-send-email-mgorman@suse.de>
 <20130702120655.GA2959@linux.vnet.ibm.com>
 <20130702181732.GD23916@twins.programming.kicks-ass.net>
 <20130706064408.GB3996@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130706064408.GB3996@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 12:14:08PM +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2013-07-02 20:17:32]:
> 
> > On Tue, Jul 02, 2013 at 05:36:55PM +0530, Srikar Dronamraju wrote:
> > > Here, moving tasks this way doesnt update the schedstats at all.
> > 
> > Do you actually use schedstats? 
> > 
> 
> Yes, I do use schedstats. Are there any plans to obsolete it?

Not really, its just something I've never used and keeping the stats correct
made Mel's patch uglier which makes me dislike them more ;-)
