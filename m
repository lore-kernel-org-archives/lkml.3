Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaKCKEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:04:36 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:35260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaKCKEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:04:30 -0500
Date: Mon, 3 Nov 2014 11:04:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Andi Kleen <ak@linux.intel.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20141103100421.GW10501@worktop.programming.kicks-ass.net>
References: <20141031111332.GA26137@gmail.com>
 <1415005321.20372.13.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415005321.20372.13.camel@x220>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 10:02:01AM +0100, Paul Bolle wrote:
> > +config PERF_EVENTS_INTEL_UNCORE
> > +	def_bool y
> > +	depends on PERF_EVENTS && SUP_SUP_INTEL && PCI
> 
> One expects this to be fixed by s/SUP_SUP_INTEL/CPU_SUP_INTEL/.

Yeah, I have that fixed; lemme try and get it in tip.
