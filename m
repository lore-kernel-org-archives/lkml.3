Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaFBTRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:17:53 -0400
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:42700 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751318AbaFBTRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:17:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865
X-HE-Tag: toys14_61332d8e5f64e
X-Filterd-Recvd-Size: 2071
Message-ID: <1401736666.7323.25.camel@joe-AO725>
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
From: Joe Perches <joe@perches.com>
To: josh@joshtriplett.org
Cc: Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Date: Mon, 02 Jun 2014 12:17:46 -0700
In-Reply-To: <20140602190951.GA13648@cloud>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1401729778.5770.20.camel@joe-AO725> <20140602174837.GA13257@cloud>
	 <1401731968.7323.4.camel@joe-AO725>
	 <20140602181658.GX22231@linux.vnet.ibm.com>
	 <1401734669.7323.20.camel@joe-AO725>
	 <20140602145020.400d4e0c@gandalf.local.home> <20140602185504.GA13569@cloud>
	 <1401735917.7323.23.camel@joe-AO725> <20140602190951.GA13648@cloud>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 12:09 -0700, josh@joshtriplett.org wrote:
> On Mon, Jun 02, 2014 at 12:05:17PM -0700, Joe Perches wrote:
> > On Mon, 2014-06-02 at 11:55 -0700, josh@joshtriplett.org wrote:
> > > this should go along with a change to
> > > get_maintainer.pl to add those folks to the CC list.
> > 
> > Something like this:
> 
> Yes, exactly.  Given an appropriate commit message,
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

That's the sort of patch where reviewing is
pretty useless.

What it needs is testing, not reviewing.

I tested it for all of 10 seconds.


