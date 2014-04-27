Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaD0Tfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 15:35:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaD0Tf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 15:35:28 -0400
Date: Sun, 27 Apr 2014 21:34:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Henrik Austad <henrik@austad.us>, Dario Faggioli <raistlin@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        rostedt@goodmis.org, Oleg Nesterov <oleg@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
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
Message-ID: <20140427193449.GB17778@laptop.programming.kicks-ass.net>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAki5BkOyckf1zxJCRs2tq-eG9bWW_yRGi3hDynz12wz+QQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 05:47:25PM +0200, Michael Kerrisk (man-pages) wrote:
> Hi Peter,
> 
> Following the review comments that one or two people sent, are you
> planning to send in a revised version of this page?

Yes, I just suck at getting around to it :-(, I'll do it first thing
tomorrow.

> Also, is there any test code lying about somewhere that I could play with?

Juri?
