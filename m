Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3JIRTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:19:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46720 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3JIRS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:18:59 -0400
Date: Wed, 9 Oct 2013 19:18:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/63] Basic scheduler support for automatic NUMA
 balancing V9
Message-ID: <20131009171849.GH13848@laptop.programming.kicks-ass.net>
References: <1381141781-10992-1-git-send-email-mgorman@suse.de>
 <20131009162801.GA10452@gmail.com>
 <20131009170837.GF13848@laptop.programming.kicks-ass.net>
 <20131009171537.GA12575@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009171537.GA12575@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 07:15:37PM +0200, Ingo Molnar wrote:
> > It looks like -march=geode generates similar borkage to the
> > -march=winchip2 like we found earlier today.
> > 
> > Must be randconfig luck to only hit it now.
> 
> Yes, very weird but such is life :-)
> 
> Also note that this reproduces with GCC 4.7 ...

Yes, it does so too for me, I tried both 4.7 and 4.8; they generate
different but similarly broken code.
