Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422857Ab3LTO2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:28:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:38105 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030201Ab3LTO2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:28:44 -0500
Date: Fri, 20 Dec 2013 09:28:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        mingo@redhat.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com
Subject: Re: [PATCH 00/13] sched, deadline: patches
Message-ID: <20131220092834.15fa2f6d@gandalf.local.home>
In-Reply-To: <52B44B56.1020903@gmail.com>
References: <20131217122720.950475833@infradead.org>
	<52B44B56.1020903@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013 14:51:18 +0100
Juri Lelli <juri.lelli@gmail.com> wrote:


> > One question; the SoB chain in patch 2/13 seems weird; I suppose that
> > patch is a collaborative effort? could we cure that by mentioning Fabio
> > and Michael in some other way?
> > 
> 
> We could change their SoB to be a Cc (not sure this cure the thing anyway). Not
> even Cc-ing them seems pointless. Then we have them mentioned in
> sched/deadline.c copyright (oh! s/2012/2014/ there :-O).

Well, if they were involved in the development of the code, then their
SoB's would be appropriate. That copyright seems to state that they are
required.

-- Steve
