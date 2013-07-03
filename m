Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435Ab3GCSrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:47:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45527 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275Ab3GCSrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:47:15 -0400
Date: Wed, 3 Jul 2013 20:46:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] sched: Reschedule task on preferred NUMA node once
 selected
Message-ID: <20130703184635.GG18898@dyad.programming.kicks-ass.net>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-7-git-send-email-mgorman@suse.de>
 <20130702181522.GC23916@twins.programming.kicks-ass.net>
 <20130703095059.GH23916@twins.programming.kicks-ass.net>
 <20130703152821.GG1875@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703152821.GG1875@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 04:28:21PM +0100, Mel Gorman wrote:

> I reshuffled the v2 series a bit to match your implied preference for layout
> and rebased this on top of the end result. May not have the beans to
> absorb it before I quit for the evening but I'll at least queue it up
> overnight.

It probably caused that snafu that got you all tangled up with your v3 series
:-) Just my luck.

I couldn't find much difference on my SpecJBB runs -- in fact so little that
I'm beginning to think I'm doing something really wrong :/
