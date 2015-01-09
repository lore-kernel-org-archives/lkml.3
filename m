Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbbAIM4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:56:33 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34252 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbbAIM4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:56:31 -0500
Date: Fri, 9 Jan 2015 12:56:27 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 11/11] perf/x86/intel: Enable conflicting event
 scheduling for CQM
Message-ID: <20150109125627.GE495@console-pimps.org>
References: <1415999712-5850-1-git-send-email-matt@console-pimps.org>
 <1415999712-5850-12-git-send-email-matt@console-pimps.org>
 <20150108114936.GJ3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108114936.GJ3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jan, at 12:49:36PM, Peter Zijlstra wrote:
> On Fri, Nov 14, 2014 at 09:15:12PM +0000, Matt Fleming wrote:
> > +/*
> > + * Deallocate the RMIDs from any events that conflict with @event, and
> > + * place them on the back of the group list.
> > + */
> > +static void intel_cqm_sched_out_events(struct perf_event *event)
> 
> I realize this function name is already very long, but how about:
> 
>   intel_cqm_sched_out_conflicting_events()
> 
> instead?

Sure. I'll make the change.

-- 
Matt Fleming, Intel Open Source Technology Center
