Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaDNLWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:22:23 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51561 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaDNLWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:22:22 -0400
Date: Mon, 14 Apr 2014 13:22:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@fb.com>,
        Kevin Hilman <khilman@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [GIT PULL v2] nohz: Move nohz kick out of scheduler IPI
Message-ID: <20140414112217.GA4050@gmail.com>
References: <1396541832-459-1-git-send-email-fweisbec@gmail.com>
 <20140409152822.GB17782@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409152822.GB17782@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Apr 03, 2014 at 06:17:10PM +0200, Frederic Weisbecker wrote:
> > Ingo, Thomas,
> > 
> > Please pull the timers/nohz-ipi-for-tip-v3 branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> > 	timers/nohz-ipi-for-tip-v3
> 
> Ping?

So this came a bit late - will it be fine for v3.16 as-is?

Thanks,

	Ingo
