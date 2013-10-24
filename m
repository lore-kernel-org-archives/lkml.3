Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab3JXOG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 10:06:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42401 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab3JXOG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 10:06:26 -0400
Date: Thu, 24 Oct 2013 16:06:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, dave.hansen@linux.intel.com,
        Stephane Eranian <eranian@google.com>, jmario@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131024140618.GD19466@laptop.lan>
References: <20131017160439.GP227855@redhat.com>
 <20131017163039.GR10651@twins.programming.kicks-ass.net>
 <CA+55aFx-1Xu2aSvAMi8SSUwq-J9Yo3oJGY8yUYWyAZmZmr8prQ@mail.gmail.com>
 <20131017220156.GB10651@twins.programming.kicks-ass.net>
 <CA+55aFyCCdwF78dM1=Km=0wqtoyosp-ChyoJuBb1DdBvmGe2vA@mail.gmail.com>
 <20131022211237.GH2490@laptop.programming.kicks-ass.net>
 <CA+55aFwfsyofuZtNyUGKPWdvqc=4gOW=HTFPxsiM-3GS1G8KKQ@mail.gmail.com>
 <20131023204838.GB19466@laptop.lan>
 <20131024105206.GM2490@laptop.programming.kicks-ass.net>
 <20131024134706.GN227855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131024134706.GN227855@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 09:47:06AM -0400, Don Zickus wrote:
> > Don, can you give this stuff a spin on your system?
> 
> I'll try to grab the machine I was testing with and see what this patch
> does.  Thanks!  I assume this can go on top of the other patch that was
> committed to -tip last week?

Yeah, I had that patch in my tree so it should apply fine.
