Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3DZQNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:13:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46128 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab3DZQNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:13:35 -0400
Date: Fri, 26 Apr 2013 18:13:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: mingo@kernel.org
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tytso@mit.edu, gorcunov@gmail.com,
        davem@davemloft.net, fweisbec@gmail.com, oleg@redhat.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/intel/P4: Robistify P4 PMU types
Message-ID: <20130426161328.GA16818@pd.tnic>
References: <20130424072630.GB1780@gmail.com>
 <tip-5ac2b5c2721501a8f5c5e1cd4116cbc31ace6886@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-5ac2b5c2721501a8f5c5e1cd4116cbc31ace6886@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 07:20:46AM -0700, tip-bot for Ingo Molnar wrote:
> Commit-ID:  5ac2b5c2721501a8f5c5e1cd4116cbc31ace6886
> Gitweb:     http://git.kernel.org/tip/5ac2b5c2721501a8f5c5e1cd4116cbc31ace6886
> Author:     Ingo Molnar <mingo@kernel.org>
> AuthorDate: Wed, 24 Apr 2013 09:26:30 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Fri, 26 Apr 2013 09:31:41 +0200
> 
> perf/x86/intel/P4: Robistify P4 PMU types
> 
> Linus found, while extending integer type extension checks in the
> sparse static code checker, various fragile patterns of mixed
> signed/unsigned  64-bit/32-bit integer use in perf_events_p4.c.
> 
> The relevant hardware register ABI is 64 bit wide on 32-bit
> kernels as  well, so clean it all up a bit, remove unnecessary
> casts, and make sure we  use 64-bit unsigned integers in these
> places.
> 
> [ Unfortunately this patch was not tested on real P4 hardware,
>   those are pretty rare already. If this patch causes any
>   problems on P4 hardware then please holler ... ]

I have a P4 and I turn it on from time to time when it's cold in the
room :-).

Any particular tests you want me to run on it?

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Pentium(R) 4 CPU 2.60GHz

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
