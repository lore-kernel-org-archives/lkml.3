Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaDNXEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:04:09 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:54276 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaDNXEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:04:07 -0400
Date: Tue, 15 Apr 2014 01:04:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@fb.com>,
        Kevin Hilman <khilman@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [GIT PULL v2] nohz: Move nohz kick out of scheduler IPI
Message-ID: <20140414230401.GB1877@localhost.localdomain>
References: <1396541832-459-1-git-send-email-fweisbec@gmail.com>
 <20140409152822.GB17782@localhost.localdomain>
 <20140414112217.GA4050@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414112217.GA4050@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 01:22:17PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Thu, Apr 03, 2014 at 06:17:10PM +0200, Frederic Weisbecker wrote:
> > > Ingo, Thomas,
> > > 
> > > Please pull the timers/nohz-ipi-for-tip-v3 branch that can be found at:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> > > 	timers/nohz-ipi-for-tip-v3
> > 
> > Ping?
> 
> So this came a bit late - will it be fine for v3.16 as-is?

It was late on purpose due to dependencies on the block tree. But nevermind.

It's still fine to be pulled as is after -rc1 for 3.16.

Thanks!
 
> Thanks,
> 
> 	Ingo
