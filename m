Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbaD1Hia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 03:38:30 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47814 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaD1Hi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 03:38:28 -0400
Date: Mon, 28 Apr 2014 09:39:01 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Henrik Austad <henrik@austad.us>, Dario Faggioli <raistlin@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        rostedt@goodmis.org, Oleg Nesterov <oleg@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        Dhaval Giani <dhaval.giani@gmail.com>, hgu1972@gmail.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Insop Song <insop.song@gmail.com>, liming.wang@windriver.com,
        jkacur@redhat.com, linux-man <linux-man@vger.kernel.org>
Subject: Re: sched_{set,get}attr() manpage
Message-Id: <20140428093901.c76e118c570df5da728b8310@gmail.com>
In-Reply-To: <20140427193449.GB17778@laptop.programming.kicks-ass.net>
References: <20131217123352.692059839@infradead.org>
	<CAHO5Pa3=+Zhg72tVfddSUvgirUyObir6atJVo4_16bVWB2Osgw@mail.gmail.com>
	<20140121153851.GZ31570@twins.programming.kicks-ass.net>
	<CAKgNAkgw+U44SH0wd_06ZMXaCC9nCX4NZxZHkMKUdC7E7YxBhQ@mail.gmail.com>
	<20140214161929.GL27965@twins.programming.kicks-ass.net>
	<53020C9D.1050208@gmail.com>
	<20140409092510.GQ11096@twins.programming.kicks-ass.net>
	<20140409151911.GA4041@austad.us>
	<20140409154204.GD10526@twins.programming.kicks-ass.net>
	<CAKgNAki5BkOyckf1zxJCRs2tq-eG9bWW_yRGi3hDynz12wz+QQ@mail.gmail.com>
	<20140427193449.GB17778@laptop.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2014 21:34:49 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, Apr 27, 2014 at 05:47:25PM +0200, Michael Kerrisk (man-pages) wrote:
> > Hi Peter,
> > 
> > Following the review comments that one or two people sent, are you
> > planning to send in a revised version of this page?
> 
> Yes, I just suck at getting around to it :-(, I'll do it first thing
> tomorrow.
> 
> > Also, is there any test code lying about somewhere that I could play with?
> 
> Juri?

Yes. I use this two tools:

- rt-app (to create periodic workload, also not RT/DL)
  https://github.com/gbagnoli/rt-app

- schedtool-dl (patched version of schetool)
  https://github.com/jlelli/schedtool-dl

Both are aligned to the last interface.

Best,

- Juri
