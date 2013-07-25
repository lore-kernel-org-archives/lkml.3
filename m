Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab3GYMdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:33:49 -0400
Received: from smtpauth12.mfg.siteprotect.com ([64.26.60.150]:41332 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755358Ab3GYMdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:33:46 -0400
Date: Thu, 25 Jul 2013 08:34:51 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Adrian Hunter <adrian.hunter@intel.com>
cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Update perf_event_type documentation
In-Reply-To: <51F0C41C.8080005@intel.com>
Message-ID: <alpine.DEB.2.02.1307250832010.18434@pianoman.cluster.toy>
References: <20130716150907.GL23818@dyad.programming.kicks-ass.net> <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org> <alpine.DEB.2.02.1307241348250.7828@pianoman.cluster.toy> <51F0C41C.8080005@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A02020A.51F11B2A.0116,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013, Adrian Hunter wrote:

> On 24/07/13 20:54, Vince Weaver wrote:
> > On Tue, 23 Jul 2013, tip-bot for Peter Zijlstra wrote:
> > 
> >> Commit-ID:  a5cdd40c9877e9aba704c020fd65d26b5cfecf18
> >> Gitweb:     http://git.kernel.org/tip/a5cdd40c9877e9aba704c020fd65d26b5cfecf18
> >> Author:     Peter Zijlstra <peterz@infradead.org>
> >> AuthorDate: Tue, 16 Jul 2013 17:09:07 +0200
> >> Committer:  Ingo Molnar <mingo@kernel.org>
> >> CommitDate: Tue, 23 Jul 2013 12:17:08 +0200
> >>
> >> perf: Update perf_event_type documentation
> >>
> >> Due to a discussion with Adrian I had a good look at the perf_event_type record
> >> layout and found the documentation to be somewhat unclear.

> ...

> This is not the patch that adds new sample format bits.
> 
> New sample format bits are always backward compatible in the sense that the
> kernel perf_event_open system call will return an error if you try to use
> sample format bits that it does not know about.

Yes, I meant the addition of the sample_id fields to the existing sample 
values.  Though if Peter is right and those have always been there since 
the beginning and just not documented then that won't break anything.  
The commit message wasn't really as clear as it could be.

Vince
