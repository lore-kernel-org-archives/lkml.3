Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab3G0DTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 23:19:13 -0400
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:35470 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758214Ab3G0DTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 23:19:09 -0400
Date: Fri, 26 Jul 2013 23:20:00 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <peterz@infradead.org>
cc: Adrian Hunter <adrian.hunter@intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Update perf_event_type documentation
In-Reply-To: <20130726085730.GD27075@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1307262316590.6448@pianoman.cluster.toy>
References: <20130716150907.GL23818@dyad.programming.kicks-ass.net> <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org> <alpine.DEB.2.02.1307241348250.7828@pianoman.cluster.toy> <51F0C41C.8080005@intel.com> <alpine.DEB.2.02.1307252313460.26062@pianoman.cluster.toy>
 <20130726085730.GD27075@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020201.51F33C2B.0057,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013, Peter Zijlstra wrote:

> On Thu, Jul 25, 2013 at 11:20:24PM -0400, Vince Weaver wrote:
> > 
> > a thing that personally bothers me are these imaginary struct definitions 
> > added as part of the documentation that aren't actually available in the 
> > public perf_event.h
> > 
> > I can see why it's done, but it can be confusing picking out in later 
> > definitions which struct fields are real and which ones are conceptual.
> 
> Would it help if we changed the syntax to not look as much as real C
> would?

I've been thinking and I can't really think of a clearer way to present 
the layout.   So I guess it's fine the way it is.  Hopefully not many 
people are stuck having to implement code based on header file comments 
anyway.

> > It might be clearer
> > if you stuck the perf_event_attr::sample_id_all qualifier each
> > place you add the sample_id field.
> 
> Ah, I actually considered that but then got lazy and used the 0 sized
> struct idea :/

It might just be me.  For whatever reason the C parser in my head doesn't 
handle GNU extensions like 0-sized structs.

Vince
