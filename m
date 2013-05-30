Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967807Ab3E3HZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:25:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40428 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967687Ab3E3HZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:25:55 -0400
Date: Thu, 30 May 2013 09:25:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: OOPS in perf_mmap_close()
Message-ID: <20130530072532.GF4341@laptop>
References: <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523125218.GB23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu>
 <20130523152611.GE23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu>
 <20130528085548.GA12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305281418120.19080@vincent-weaver-1.um.maine.edu>
 <20130529074433.GB12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305291516310.2609@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1305291516310.2609@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 03:18:32PM -0400, Vince Weaver wrote:
> On Wed, 29 May 2013, Peter Zijlstra wrote:
> > 
> > Hurm.. I don't suppose you have an easy reproducer handy eh? I'll go
> > stare at it. At least the current state is better than before, but
> > clearly we're not quite there yet.
> 
> OK, below is an easy reproducer.  Just run it two or three times.
> It leaks 129 pages in user->locked_vm each time you run it.
> 
> It took me a while to bisect this down from 10,000 syscalls to just 3.
> I now have a tool that can generate valid perf test_cases from my fuzzer 
> traces, which should be useful.

Awesome! How specific is it to perf? I mean, would that tool work
equally well for other tinity report?

I'll go prod, thanks again!
