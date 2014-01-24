Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaAXS2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:28:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:22301 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaAXS2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:28:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,714,1384329600"; 
   d="scan'208";a="470355996"
Message-ID: <1390587227.912.18.camel@dvhart-mobl.amr.corp.intel.com>
Subject: Re: [PATCH 0/3] perf-bench: introduce futex microbenchmarks
From: Darren Hart <dvhart@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, jason.low2@hp.com, Waiman.Long@hp.com,
        scott.norton@hp.com, aswin@hp.com
Date: Fri, 24 Jan 2014 10:13:47 -0800
In-Reply-To: <1387205098.2797.3.camel@buesod1.americas.hpqcorp.net>
References: <1387081917-9102-1-git-send-email-davidlohr@hp.com>
	 <20131216100828.GA21304@gmail.com>
	 <1387205098.2797.3.camel@buesod1.americas.hpqcorp.net>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-16 at 06:44 -0800, Davidlohr Bueso wrote:
> On Mon, 2013-12-16 at 11:08 +0100, Ingo Molnar wrote:
> > * Davidlohr Bueso <davidlohr@hp.com> wrote:
> > 
> > > This patchset adds three programs that stress and measure different 
> > > futex operations: (i) uaddr hashing, (ii) wakeups and (iii) 
> > > requeuing/waiting.
> > > 
> > > More details and usage examples in each individual patch, along with 
> > > parameter descriptions in the code.
> > > 
> > > While the previous effort (https://lkml.org/lkml/2012/5/17/207) to 
> > > add futex benchmarks to perf-bench failed, I strongly believe that 
> > > perf is an ideal place for these kinds of programs. This patchset is 
> > > different from Hitoshi's because it does not try to take over 
> > > Darren's futextest suite, and only deals with finer grained aspects 
> > > of the kernel's implementation, and thus mostly useful for kernel 
> > > hacking. Furthermore, by being part of the kernel tree, it can get 
> > > more attention and naturally evolve with time.
> > 
> > Looks pretty useful!
> > 
> > Could the two approaches be merged?
> 
> Unless Darren doesn't want to, I don't see why not. I can resurrect
> Hitoshi's original patch if/after this series is applied.

Apologies, I only am just now seeing this.

I agree that we should take whatever makes sense for perf out of
futex-test and merge it with perf. It will see greater use and receive
more review and improvements than it will in my obscure repository.

With trinity covering the fuzz testing and perf handling performance
tests, I think futex-test can be reduced down to a functional
test-suite, which is perfectly fine with me.

If there is still interest here, I'll support it.

Thanks,

Darren

