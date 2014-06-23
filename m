Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbaFWMxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:53:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59216 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaFWMxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:53:17 -0400
Date: Mon, 23 Jun 2014 14:53:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [GIT PULL] nohz: Move nohz kick out of scheduler IPI, v9
Message-ID: <20140623125309.GA19860@laptop.programming.kicks-ass.net>
References: <1402935790-19860-1-git-send-email-fweisbec@gmail.com>
 <20140618164841.GA19204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618164841.GA19204@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 06:48:41PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > Please pull the timers/nohz-irq-work-v7 branch that can be found at:
> > 
> 
> Pulled, thanks a lot Frederic!

Ingo, the previous version had one of your machines fall over, is that
machine good now?
