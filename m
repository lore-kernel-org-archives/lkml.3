Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab3EJJgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:36:04 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:43220 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab3EJJgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:36:02 -0400
Date: Fri, 10 May 2013 11:35:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, jamie.iles@oracle.com,
        penberg@kernel.org, acme@ghostprotocols.net, paulus@samba.org,
        namhyung@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 8/9] liblockdep: Add the 'lockdep' user-space utility
Message-ID: <20130510093557.GA16429@gmail.com>
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com>
 <1368115089-8909-9-git-send-email-sasha.levin@oracle.com>
 <20130510091912.GD3039@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510091912.GD3039@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, May 09, 2013 at 11:58:08AM -0400, Sasha Levin wrote:
> > This is a simple wrapper to make using liblockdep on existing
> > applications much easier.
> > 
> > After running 'make && make install', it becomes quite simple to
> > test things with liblockdep. For example, to try it on perf:
> > 
> > 	lockdep perf
> > 
> > No other integration required.
> > 
> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> > Cc: jamie.iles@oracle.com
> > Cc: penberg@kernel.org
> > Cc: acme@ghostprotocols.net
> > Cc: paulus@samba.org
> > Cc: namhyung@kernel.org
> 
> > Cc: peterz@infradead.org
> 
> That's me
> 
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> That too..
> 
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Link: http://lkml.kernel.org/r/1360456781-32462-11-git-send-email-sasha.levin@oracle.com
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> I was wondering why I kept getting this particular patch twice every time..

If you started acking and emailing from the same address you'd only get 
one! :-)

Thanks,

	Ingo
