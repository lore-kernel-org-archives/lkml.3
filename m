Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168Ab3GaKDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:03:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884Ab3GaKDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:03:37 -0400
Date: Wed, 31 Jul 2013 11:03:31 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/18] sched: Retry migration of tasks to CPU on a
 preferred node
Message-ID: <20130731100330.GO2296@suse.de>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <1373901620-2021-18-git-send-email-mgorman@suse.de>
 <20130725103352.GK27075@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130725103352.GK27075@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 12:33:52PM +0200, Peter Zijlstra wrote:
> 
> Subject: stop_machine: Introduce stop_two_cpus()
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Sun Jul 21 12:24:09 CEST 2013
> 
> Introduce stop_two_cpus() in order to allow controlled swapping of two
> tasks. It repurposes the stop_machine() state machine but only stops
> the two cpus which we can do with on-stack structures and avoid
> machine wide synchronization issues.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Clever! I did not spot any problems so will be pulling this (and
presumably the next patch) into the series. Thanks!

-- 
Mel Gorman
SUSE Labs
