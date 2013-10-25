Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3JYRDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 13:03:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39876 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3JYRDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 13:03:15 -0400
Date: Fri, 25 Oct 2013 19:03:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, dave.hansen@linux.intel.com,
        Stephane Eranian <eranian@google.com>, jmario@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131025170306.GF19466@laptop.lan>
References: <20131017160439.GP227855@redhat.com>
 <20131017163039.GR10651@twins.programming.kicks-ass.net>
 <CA+55aFx-1Xu2aSvAMi8SSUwq-J9Yo3oJGY8yUYWyAZmZmr8prQ@mail.gmail.com>
 <20131017220156.GB10651@twins.programming.kicks-ass.net>
 <CA+55aFyCCdwF78dM1=Km=0wqtoyosp-ChyoJuBb1DdBvmGe2vA@mail.gmail.com>
 <20131022211237.GH2490@laptop.programming.kicks-ass.net>
 <CA+55aFwfsyofuZtNyUGKPWdvqc=4gOW=HTFPxsiM-3GS1G8KKQ@mail.gmail.com>
 <20131023204838.GB19466@laptop.lan>
 <20131024105206.GM2490@laptop.programming.kicks-ass.net>
 <20131025163303.GD108330@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025163303.GD108330@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 12:33:03PM -0400, Don Zickus wrote:
> Hi Peter,
> 
> I finally had a chance to run this on my machine.  From my testing, it
> looks good.  Better performance numbers.  I think my longest latency went
> from 300K cycles down to 150K cycles and very few of those (most are under
> 100K cycles).
> 
> I also don't see perf throttling me down to 1500 samples, it stops around
> 7000.  So I see progress with this patch. :-)

Awesome.. I'll write up a proper patch when I'm back home.
