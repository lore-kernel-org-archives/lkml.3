Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaEGVZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:25:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61150 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814AbaEGVZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:25:01 -0400
Date: Wed, 7 May 2014 22:23:54 +0100
From: Will Deacon <will.deacon@arm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch/rfc] perf on raspberry-pi without overflow interrupt
Message-ID: <20140507212354.GC5311@arm.com>
References: <20140110094056.GK31570@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1401132344570.20155@vincent-weaver-1.um.maine.edu>
 <20140114105721.GU7572@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1401161209280.1996@vincent-weaver-1.um.maine.edu>
 <20140116173110.GA9655@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1401170041350.4747@vincent-weaver-1.um.maine.edu>
 <20140224104634.GA2553@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1402241035510.19768@vincent-weaver-1.um.maine.edu>
 <20140507172924.GE3694@arm.com>
 <alpine.DEB.2.10.1405071719430.7020@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405071719430.7020@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 10:21:52PM +0100, Vince Weaver wrote:
> On Wed, 7 May 2014, Will Deacon wrote:
> 
> > > OK, let me revisit the patches.  The last set of generic ones I sent out 
> > > actually was broken on ARM and I've been meaning to straighten things out 
> > > and send a proper follow up patch set but got distracted by other perf 
> > > related issues.
> > 
> > Any luck with this? I just got (another) report of a PMU with borked
> > interrupts, so a fix would be great if you've got one.
> 
> Let me see if I can get a final patch out for that.
> 
> I've been working on it off and on, the problem is that the patch that 
> enables things on the Raspberry Pi somehow breaks sampled events on my 
> pandaboard.
> 
> Let me compile up some new kernels and do some more testing and hopefully 
> get this sorted out this week.

Cheers Vince, much appreciated. I can help test if you need it (my broken
boards will come in useful at last!)

Will
