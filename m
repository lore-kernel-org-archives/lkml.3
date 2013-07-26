Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab3GZIzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 04:55:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57967 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3GZIzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 04:55:33 -0400
Date: Fri, 26 Jul 2013 10:55:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: Adrian Hunter <adrian.hunter@intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Update perf_event_type documentation
Message-ID: <20130726085520.GC27075@twins.programming.kicks-ass.net>
References: <20130716150907.GL23818@dyad.programming.kicks-ass.net>
 <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org>
 <alpine.DEB.2.02.1307241348250.7828@pianoman.cluster.toy>
 <51F0C41C.8080005@intel.com>
 <alpine.DEB.2.02.1307250832010.18434@pianoman.cluster.toy>
 <20130725162749.GW27075@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1307252320520.26062@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307252320520.26062@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 11:24:05PM -0400, Vince Weaver wrote:
> On Thu, 25 Jul 2013, Peter Zijlstra wrote:
> 
> > On Thu, Jul 25, 2013 at 08:34:51AM -0400, Vince Weaver wrote:
> > > Yes, I meant the addition of the sample_id fields to the existing sample 
> > > values.  Though if Peter is right and those have always been there since 
> > > the beginning and just not documented then that won't break anything.  
> > > The commit message wasn't really as clear as it could be.
> > 
> > /me writes "I shall write better Changelogs." a hundred times.
> 
> yes, sorry, I shouldn't have been so grumpy about it.

I don't mind; I wish people would tell me my changelogs suck before they
get committed though; I can still fix them at that point.

It not only helps others, but also myself. I've on many occasion kicked
myself for not writing clearer changelogs when investigating something
months (or years) after I wrote the initial code.

The problem is that I mostly know what I mean when I write it and I'm
not very good at writing in the first place -- real changelogs often
take longer to write than the actual code. But I guess that's true for
many people.

Anyway.. I'm ever trying to write better changelogs, but alas there's
also always far more room for improvement :-)
