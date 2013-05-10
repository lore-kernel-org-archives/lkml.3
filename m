Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab3EJJix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:38:53 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:40484 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab3EJJiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:38:52 -0400
Date: Fri, 10 May 2013 11:38:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/9] liblockdep: Wrap kernel/lockdep.c to allow usage
 from userspace
Message-ID: <20130510093848.GB16487@gmail.com>
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com>
 <1368115089-8909-3-git-send-email-sasha.levin@oracle.com>
 <20130510091816.GC3039@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510091816.GC3039@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, May 09, 2013 at 11:58:02AM -0400, Sasha Levin wrote:
> > kernel/lockdep.c deals with validating locking scenarios for
> > various architectures supported by the kernel. There isn't
> > anything kernel specific going on in lockdep, and when we
> > compare userspace to other architectures that don't have to deal
> > with irqs such as s390, they become all too similar.
> > 
> > We wrap kernel/lockdep.c and include/linux/lockdep.h with
> > several headers which allow us to build and use lockdep from
> > userspace. We don't touch the kernel code itself which means
> > that any work done on lockdep in the kernel will automatically
> > benefit userspace lockdep as well!
> > 
> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> > ---
> 
> OK, this patch is a complete fail with anything not git. Please fix it so I can
> use quilt.

The way I work that around is by making empty files a single-line empty 
file, with a single \n in them.

Thanks,

	Ingo
