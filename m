Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab3HTPyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:54:43 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:42220 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3HTPym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:54:42 -0400
Date: Tue, 20 Aug 2013 18:53:40 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: [sched next] overflowed cpu time for kernel threads in
 /proc/PID/stat
Message-ID: <20130820155340.GC2315@swordfish.minsk.epam.com>
References: <20130820111426.GA27828@swordfish.datadirectnet.com>
 <20130820151509.GA17441@somewhere>
 <20130820153549.GB2315@swordfish.minsk.epam.com>
 <20130820154257.GD17441@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820154257.GD17441@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/20/13 17:42), Frederic Weisbecker wrote:
> On Tue, Aug 20, 2013 at 06:35:50PM +0300, Sergey Senozhatsky wrote:
> > On (08/20/13 17:15), Frederic Weisbecker wrote:
> > > On Tue, Aug 20, 2013 at 02:14:26PM +0300, Sergey Senozhatsky wrote:
> > > Hello,
> > > 
> > > Please upload your config.
> > > 
> > > I'm adding Stanislaw in Cc in case it relates to cputime scaling.
> > >
> > 
> > please find attached.
> > 
> > 	-ss
> 
> > #
> > # CPU/Task time and stats accounting
> > #
> > CONFIG_VIRT_CPU_ACCOUNTING=y
> > CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
> 
> So it happens with full dynticks cputime accounting.

yes.

> How reproducable is this?

compiling something big enough (e.g. kernel) `works' for me.

> Does it always happen?

I'd say yes.

> Does it happen with CONFIG_TICK_CPU_ACCOUNTING as well? (you'll
> need to deactivate full dynticks.)

will test.

	-ss

> Thanks.
> 
