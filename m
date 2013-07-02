Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab3GBI43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:56:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40793 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab3GBI40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:56:26 -0400
Date: Tue, 2 Jul 2013 10:55:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Basic scheduler support for automatic NUMA balancing
Message-ID: <20130702085546.GE21726@dyad.programming.kicks-ass.net>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <20130628135422.GA21895@linux.vnet.ibm.com>
 <20130702074659.GC21726@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130702074659.GC21726@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 09:46:59AM +0200, Peter Zijlstra wrote:
> So on the biggest system I've got; 4 nodes 32 cpus:
> 
>  Performance counter stats for './numa02' (5 runs):
> 
> 3.10.0+ + patches - NO_NUMA	58.235353126 seconds time elapsed    ( +-  0.45% )
> 3.10.0+ + patches -    NUMA   17.580963359 seconds time elapsed    ( +-  0.09% )

I just 'noticed' that I included my migrate_degrades_locality patch -- the one
posted somewhere in this thread (+ compile fixes).

Let me re-run without that one to see if there's any difference.

NO_NUMA		57.961384751 seconds time elapsed    ( +-  0.64% )
   NUMA		17.482115801 seconds time elapsed    ( +-  0.15% )
