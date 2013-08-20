Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab3HTPnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:43:04 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:65439 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3HTPnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:43:02 -0400
Date: Tue, 20 Aug 2013 17:42:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: [sched next] overflowed cpu time for kernel threads in
 /proc/PID/stat
Message-ID: <20130820154257.GD17441@somewhere>
References: <20130820111426.GA27828@swordfish.datadirectnet.com>
 <20130820151509.GA17441@somewhere>
 <20130820153549.GB2315@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820153549.GB2315@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 06:35:50PM +0300, Sergey Senozhatsky wrote:
> On (08/20/13 17:15), Frederic Weisbecker wrote:
> > On Tue, Aug 20, 2013 at 02:14:26PM +0300, Sergey Senozhatsky wrote:
> > Hello,
> > 
> > Please upload your config.
> > 
> > I'm adding Stanislaw in Cc in case it relates to cputime scaling.
> >
> 
> please find attached.
> 
> 	-ss

> #
> # CPU/Task time and stats accounting
> #
> CONFIG_VIRT_CPU_ACCOUNTING=y
> CONFIG_VIRT_CPU_ACCOUNTING_GEN=y

So it happens with full dynticks cputime accounting.
How reproducable is this? Does it always happen?
Does it happen with CONFIG_TICK_CPU_ACCOUNTING as well? (you'll
need to deactivate full dynticks.)

Thanks.
