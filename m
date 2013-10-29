Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3J2JtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:49:03 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:53278 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3J2JtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:49:00 -0400
Date: Tue, 29 Oct 2013 10:48:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Tom Weber <l_linux-kernel@mail2news.4t2.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Automatic NUMA balancing patches for tip-urgent/stable
Message-ID: <20131029094856.GA25306@gmail.com>
References: <1381141781-10992-1-git-send-email-mgorman@suse.de>
 <20131024122646.GB2402@suse.de>
 <20131026121148.GC24439@gmail.com>
 <20131029094208.GB2400@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029094208.GB2400@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> > Would be nice if you gave me all the specific SHA1 tags of 
> > sched/core that are required for the fix. We can certainly use a 
> > range to make it all safer to apply.
> 
> Of course. The range of the relevant commits in tip/sched/core is
> ca4be374c5c0ab3d8b84fb2861d663216281e6ac..778ec5247bb79815af12434980164334fb94cc9e
> 
> 904f64a376e663cd459fb7aec4f12e14c39c24b6 mm: numa: Document automatic NUMA balancing sysctls
> 1d649bccc8c1370e402b85e1d345ad24f3f0d1b5 sched, numa: Comment fixlets
> f961cab8d55d55d6abc0df08ce2abec8ab56f2c8 mm: numa: Do not account for a hinting fault if we raced
> 6f2a15fc1df62af3ba3be327877b7e53cb16e878 mm: Wait for THP migrations to complete during NUMA hinting faults
> 4ee547f994c633f2607d222e2c6385b6fe5f07d8 mm: Prevent parallel splits during THP migration
> dd83227f0d93fb37d7621a24e8465b13b437faa6 mm: numa: Sanitize task_numa_fault() callsites
> efeeacf7b94babff85da7e468fc5450fdfab0900 mm: Close races between THP migration and PMD numa clearing
> 778ec5247bb79815af12434980164334fb94cc9e mm: Account for a THP NUMA hinting update as one PTE update

These commits don't exist in -tip :-/

Some of these don't even exist as patch titles under different 
sha1's - such as "sched, numa: Comment fixlets".

So I'm really confused about what to pick up. What tree are you 
looking at?

-tip is at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

Thanks,

	Ingo
