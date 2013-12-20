Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3LTPTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:19:33 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:62120 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753271Ab3LTPTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:19:32 -0500
Date: Fri, 20 Dec 2013 10:19:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com
Subject: Re: [PATCH 00/13] sched, deadline: patches
Message-ID: <20131220101927.40b7689b@gandalf.local.home>
In-Reply-To: <20131220145140.GD7959@laptop.programming.kicks-ass.net>
References: <20131217122720.950475833@infradead.org>
	<52B44B56.1020903@gmail.com>
	<20131220145140.GD7959@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013 15:51:40 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Dec 20, 2013 at 02:51:18PM +0100, Juri Lelli wrote:
> > I use this: https://github.com/gbagnoli/rt-app/tree/new-ABI
> > It is aligned with the new ABI (but it is missing your last changes).
> 
> I'm a moron, I can't find how to make github get me a git:// url I can
> clone from.

I don't think you can use git:// but you can do:

git clone https://github.com/gbagnoli/rt-app.git

-- Steve
