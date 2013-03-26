Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586Ab3CZIPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 04:15:34 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:44761 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3CZIPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 04:15:32 -0400
Date: Tue, 26 Mar 2013 09:15:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] nohz: Full dynticks base interface
Message-ID: <20130326081527.GA27128@gmail.com>
References: <1363879460-21595-1-git-send-email-fweisbec@gmail.com>
 <20130324081701.GA13328@gmail.com>
 <CAFTL4hx4FLaRR6i9ap9UrCZY4ikhVtLfUqWSsjTpsO3dvShUjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hx4FLaRR6i9ap9UrCZY4ikhVtLfUqWSsjTpsO3dvShUjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > That way I will be able to test it automatically via randconfig and 
> > such.
> 
> Sure, I'm adding such an option.
> 
> > My next question/request after that would be: could we make sure that 
> > enabling this option does not break any applications or kernel 
> > functionality, ASAP? Once that is offered, it becomes pushable to 
> > v3.10 I think.
> 
> So that's already the case. I'm careful that, as we iterate, the changes 
> aren't supposed to break something in the middle. the final code that 
> eventually shuts the tick down should be the last one in the series: 
> once we know it is safe to do so.

I mean, with the .config (or boot) option enabled, with tip:timers/nohz 
as-is, will everything work? We cannot push a feature to Linus that 
doesn't work reliably when enabled ...

Thanks,

	Ingo
