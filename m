Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbaBKUeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:34:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44247 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbaBKUe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:34:26 -0500
Date: Tue, 11 Feb 2014 21:34:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH v2 6/8] perf/x86/uncore: add SNB/IVB/HSW client uncore
 memory controller support
Message-ID: <20140211203413.GB9987@twins.programming.kicks-ass.net>
References: <1392132015-14521-1-git-send-email-eranian@google.com>
 <1392132015-14521-7-git-send-email-eranian@google.com>
 <20140211161905.GS27965@twins.programming.kicks-ass.net>
 <CABPqkBRmt120Xn02sR8nhFCjuxSJ7xZbE4-G57x7rgsmB3nwNg@mail.gmail.com>
 <20140211165013.GV27965@twins.programming.kicks-ass.net>
 <CABPqkBSoW5bUret1-Rnm4AQSVrDm+CkrzuzZzdeh9HN8bsj58Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSoW5bUret1-Rnm4AQSVrDm+CkrzuzZzdeh9HN8bsj58Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 07:31:59PM +0100, Stephane Eranian wrote:
> > Anyway, perf_event_intel.c lists: 60,63,69,70,71 as being haswell
> > clients.  Andi did all that, so if its wrong its on Intel anyway.
> >
> What he has is okay for core. They all have the same core PMU at 99%.
> But the uncore can be radically different. Look at IVB (58) vs IVB-EP (62).
> So this is more risky there. That is why I did not add the other model numbers.

Well, if any of those is a !client part; then still his fault for not
putting in a comment.

What's the worst that can happen? Failing to find the hardware I suppose
seeing as this is all discoverable PCI space?
