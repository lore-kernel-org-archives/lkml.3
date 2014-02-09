Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaBIMxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 07:53:31 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:52237 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaBIMxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 07:53:30 -0500
Date: Sun, 9 Feb 2014 13:53:25 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] liblockdep fixes for v3.14
Message-ID: <20140209125325.GA23318@gmail.com>
References: <52F2C56F.5030309@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F2C56F.5030309@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> The following changes since commit 65370bdf881e20907e7a53abab9b8c0bc5f60a6b:
> 
>   Merge branch 'linus' into core/locking (2014-02-02 09:43:20 +0100)
> 
> are available in the git repository at:
> 
> 
>   https://github.com/sashalevin/liblockdep.git liblockdep-fixes
> 
> for you to fetch changes up to a521b55af18ac72c969c1ba41b660d77dae37357:
> 
>   liblockdep: add a stub for new rcu_is_watching (2014-02-05 18:03:54 -0500)
> 
> ----------------------------------------------------------------
> Ira W. Snyder (3):
>       tools: lockdep: fix initialization code path
>       tools: lockdep: fix include of asm/hash.h
>       tools: lockdep: add include directory to allow tests to compile
> 
> Sasha Levin (2):
>       liblockdep: mark runtests.sh as executable
>       liblockdep: add a stub for new rcu_is_watching

So I have a couple of nits about the commits:

1)

Please use the following standard tags/prefixes:

   tools/liblockdep: Fix initialization code path
   ...

and also capitalize sentences properly.

2)

Faulty SOB sequences:

 Author: Ira W. Snyder <iws@ovro.caltech.edu>
 Date:   Fri Jan 31 13:35:32 2014 -0800

    tools: lockdep: add include directory to allow tests to compile

    Acked-by: Sasha Levin <sasha.levin@oracle.com>
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>


That's not how we do signoffs, maintainer commits should be:

	Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
	Signed-off-by: Sasha Levin <sasha.levin@oracle.com>


As a side note, that's not a valid Ack sequence either, which if done 
should be the other way around:

    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Acked-by: Sasha Levin <sasha.levin@oracle.com>

3)

It's not clear which patch you are referring to here:

    This patch mirrors the fix used for perf, titled "tools: perf: 
    util: fix include for non x86 architectures".

It's neither in the series, nor in upstream.

Thanks,

	Ingo
