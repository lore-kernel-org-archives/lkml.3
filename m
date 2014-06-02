Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaFBR7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:59:36 -0400
Received: from smtprelay0205.hostedemail.com ([216.40.44.205]:48433 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752392AbaFBR7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:59:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:2892:3138:3139:3140:3141:3142:3352:362
X-HE-Tag: knife80_8d25dcc3eaa02
X-Filterd-Recvd-Size: 2124
Message-ID: <1401731968.7323.4.camel@joe-AO725>
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
From: Joe Perches <joe@perches.com>
To: josh@joshtriplett.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Date: Mon, 02 Jun 2014 10:59:28 -0700
In-Reply-To: <20140602174837.GA13257@cloud>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1401729778.5770.20.camel@joe-AO725> <20140602174837.GA13257@cloud>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 10:48 -0700, josh@joshtriplett.org wrote:
> On Mon, Jun 02, 2014 at 10:22:58AM -0700, Joe Perches wrote:
> > On Mon, 2014-06-02 at 10:00 -0700, Paul E. McKenney wrote:
> > > A ksummit-discuss email thread looked at the difficulty recruiting
> > > and retaining reviewers.
> > 
> > []
> > 
> > > Paul Walmsley also noted the need for patch
> > > submitters to know who the key reviewers are and suggested adding an
> > > "R:" tag to the MAINTAINERS file to record this information on a
> > > per-subsystem basis.
> > 
> > I'm not sure of the value of this.
> > 
> > Why not just mark the actual reviewers as maintainers?
> 
> As discussed in the kernel summit discussion, being a regular patch
> reviewer isn't the same thing as being *the* maintainer.

I think it's not particularly important or valuable
here to make that distinction.

What real difference does it make?


