Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab3I3G1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 02:27:41 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:59767 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3I3G1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 02:27:39 -0400
Date: Mon, 30 Sep 2013 08:27:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130930062735.GA13482@gmail.com>
References: <20130928180327.GA5000@gmail.com>
 <20130929114700.GB282@x4>
 <20130929213329.GA2125@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130929213329.GA2125@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> > breaks "perf top" on my machine. I just see a gray screen with no text
> > at all. Sometimes the following error messages are printed:
> >  *** Error in `perf': invalid fastbin entry (free): 0x00000000029b18c0 ***
> >  *** Error in `perf': malloc(): memory corruption (fast): 0x0000000000ee0b10 ***
> 
> Hmm, works for me. In fact I wrote it to fix a perf top issue.

What 'issue' and why wasn't it described in the changelog more accurately?

The blurb you wrote in the changelog:

| The libbfd C++ demangler doesn't seem to deal with cloned functions, 
| like symbol.clone.NUM.
|
| Just strip the dot part before demangling and add it back later.

Only alludes to a C++ symbol resolution annoyance and thus isn't very 
informative.

	Ingo
