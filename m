Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaD0TqE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 15:46:04 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:2819 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754069AbaD0TqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 15:46:02 -0400
Date: Sun, 27 Apr 2014 15:45:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Henrik Austad <henrik@austad.us>, Dario Faggioli <raistlin@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        =?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, Dhaval Giani <dhaval.giani@gmail.com>,
        hgu1972@gmail.com, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Insop Song <insop.song@gmail.com>, liming.wang@windriver.com,
        jkacur@redhat.com, linux-man <linux-man@vger.kernel.org>
Subject: Re: sched_{set,get}attr() manpage
Message-ID: <20140427154558.6b7c761b@gandalf.local.home>
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
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2014 21:34:49 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> > Also, is there any test code lying about somewhere that I could play with?

I have a deadline program you can play with too:

http://rostedt.homelinux.com/private/deadline.c

-- Steve
