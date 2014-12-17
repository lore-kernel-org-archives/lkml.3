Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230AbaLQROr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:14:47 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:35917 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaLQROq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:14:46 -0500
Date: Wed, 17 Dec 2014 18:14:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141217171404.GD30905@twins.programming.kicks-ass.net>
References: <CA+55aFyt6q7Ed-SS9GeN8jeUZu6yNM14EGyH_8rn8AF2Vv37hg@mail.gmail.com>
 <alpine.DEB.2.11.1411212207150.6439@nanos>
 <CA+55aFyzg=vJqRwh2CsK8WD-E5nRPjdiasMaTBx6qygQhDrGLA@mail.gmail.com>
 <20141216192803.GC3337@twins.programming.kicks-ass.net>
 <CA+55aFx9oTQHnamJ=QEGOKHe2obQEn2NfNa+hJ_Z-V1FyY7QaQ@mail.gmail.com>
 <20141216211921.GA2395@suse.de>
 <20141216230246.GA30905@twins.programming.kicks-ass.net>
 <CA+55aFxyx_wcsgYJC2GXcjEvMsTg=K=uy6A=xDJdWdvZsE1VHQ@mail.gmail.com>
 <CALCETrVLrXOZNY6Xha+TukJMTb2ni70FN==rL8KHM6FrMwWzVQ@mail.gmail.com>
 <20141217170139.GB8142@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217170139.GB8142@laptop.dumpdata.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 12:01:39PM -0500, Konrad Rzeszutek Wilk wrote:
> > Linus, do you have a pointer to whatever version of the patch you tried?
> 
> The patch was this:
> 
> a) http://article.gmane.org/gmane.linux.kernel/1835331
> 
> Then Jurgen had a patch:
> https://lkml.kernel.org/g/CA+55aFxSRujj=cM1NkXYvxmo=Y1hb1e3tgLhdh1JDphzV6WKRw@mail.gmail.com
> which was one fix for one bug that ended up being fixed in QEMU - so
> it can be ignored.
> 
> But my understanding of that thread was that it said patch 'a)' did not
> fix Dave's issues - and the conversation went off on NMI watchdog?
> 
> I will look up the giant thread to make sense.

No, you're right in that the patch didn't solve the issue at hand and
that the conversation moved on into a different direction.

But I would very much like to see it (or something very much like it)
happen, because it does make the code much saner.
