Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab3LPOpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 09:45:04 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:39738 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3LPOpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 09:45:03 -0500
Message-ID: <1387205098.2797.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/3] perf-bench: introduce futex microbenchmarks
From: Davidlohr Bueso <davidlohr@hp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@redhat.com,
        dvhart@linux.intel.com, peterz@infradead.org, tglx@linutronix.de,
        jason.low2@hp.com, Waiman.Long@hp.com, scott.norton@hp.com,
        aswin@hp.com
Date: Mon, 16 Dec 2013 06:44:58 -0800
In-Reply-To: <20131216100828.GA21304@gmail.com>
References: <1387081917-9102-1-git-send-email-davidlohr@hp.com>
	 <20131216100828.GA21304@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-16 at 11:08 +0100, Ingo Molnar wrote:
> * Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
> > This patchset adds three programs that stress and measure different 
> > futex operations: (i) uaddr hashing, (ii) wakeups and (iii) 
> > requeuing/waiting.
> > 
> > More details and usage examples in each individual patch, along with 
> > parameter descriptions in the code.
> > 
> > While the previous effort (https://lkml.org/lkml/2012/5/17/207) to 
> > add futex benchmarks to perf-bench failed, I strongly believe that 
> > perf is an ideal place for these kinds of programs. This patchset is 
> > different from Hitoshi's because it does not try to take over 
> > Darren's futextest suite, and only deals with finer grained aspects 
> > of the kernel's implementation, and thus mostly useful for kernel 
> > hacking. Furthermore, by being part of the kernel tree, it can get 
> > more attention and naturally evolve with time.
> 
> Looks pretty useful!
> 
> Could the two approaches be merged?

Unless Darren doesn't want to, I don't see why not. I can resurrect
Hitoshi's original patch if/after this series is applied.

Thanks,
Davidlohr

