Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaFBTga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:36:30 -0400
Received: from smtprelay0060.hostedemail.com ([216.40.44.60]:57961 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752659AbaFBTg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:36:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:2895:3138:3139:3140:3141:3142:3352:
X-HE-Tag: leg00_7228daf4f4650
X-Filterd-Recvd-Size: 2730
Message-ID: <1401737782.7323.31.camel@joe-AO725>
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
From: Joe Perches <joe@perches.com>
To: paulmck@linux.vnet.ibm.com
Cc: josh@joshtriplett.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Date: Mon, 02 Jun 2014 12:36:22 -0700
In-Reply-To: <20140602192729.GB22231@linux.vnet.ibm.com>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1401729778.5770.20.camel@joe-AO725> <20140602174837.GA13257@cloud>
	 <1401731968.7323.4.camel@joe-AO725>
	 <20140602181658.GX22231@linux.vnet.ibm.com> <20140602185635.GB13569@cloud>
	 <20140602190821.GZ22231@linux.vnet.ibm.com> <20140602191155.GB13648@cloud>
	 <20140602192729.GB22231@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 12:27 -0700, Paul E. McKenney wrote:
> On Mon, Jun 02, 2014 at 12:11:55PM -0700, josh@joshtriplett.org wrote:
> > 
> > I'd suggest adding Mathieu Desnoyers, Oleg Nesterov, and Lai Jiangshan
> > as reviewers as well, with their consent.
> 
> Mathieu, Oleg, Lai, any objections?

I suggest not going overboard with R entries.
If there are more than 1 or 2, create a mailing list.

And more entries will just make the churn and name-decay
in MAINTAINERS that much more prevalent.

None of those people have any significant
quantities of commit entries for rcu

(with the get_maintainer patch posted)

$ ./scripts/get_maintainer.pl -f kernel/rcu/ --git --git-min-percent=3
Dipankar Sarma <dipankar@in.ibm.com> (supporter:READ-COPY UPDATE...)
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> (supporter:READ-COPY UPDATE...,commit_signer:82/85=96%,authored:58/85=68%)
Josh Triplett <josh@joshtriplett.org> (reviewer,commit_signer:56/85=66%)
Ingo Molnar <mingo@kernel.org> (commit_signer:5/85=6%)
Peter Zijlstra <peterz@infradead.org> (commit_signer:5/85=6%)
Thomas Gleixner <tglx@linutronix.de> (commit_signer:3/85=4%)
Andreea-Cristina Bernat <bernat.ada@gmail.com> (authored:3/85=4%)
linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)



