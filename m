Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab3LPKIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:08:34 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:47116 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3LPKId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:08:33 -0500
Date: Mon, 16 Dec 2013 11:08:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@redhat.com,
        dvhart@linux.intel.com, peterz@infradead.org, tglx@linutronix.de,
        jason.low2@hp.com, Waiman.Long@hp.com, scott.norton@hp.com,
        aswin@hp.com
Subject: Re: [PATCH 0/3] perf-bench: introduce futex microbenchmarks
Message-ID: <20131216100828.GA21304@gmail.com>
References: <1387081917-9102-1-git-send-email-davidlohr@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387081917-9102-1-git-send-email-davidlohr@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davidlohr Bueso <davidlohr@hp.com> wrote:

> This patchset adds three programs that stress and measure different 
> futex operations: (i) uaddr hashing, (ii) wakeups and (iii) 
> requeuing/waiting.
> 
> More details and usage examples in each individual patch, along with 
> parameter descriptions in the code.
> 
> While the previous effort (https://lkml.org/lkml/2012/5/17/207) to 
> add futex benchmarks to perf-bench failed, I strongly believe that 
> perf is an ideal place for these kinds of programs. This patchset is 
> different from Hitoshi's because it does not try to take over 
> Darren's futextest suite, and only deals with finer grained aspects 
> of the kernel's implementation, and thus mostly useful for kernel 
> hacking. Furthermore, by being part of the kernel tree, it can get 
> more attention and naturally evolve with time.

Looks pretty useful!

Could the two approaches be merged?

Thanks,

	Ingo
