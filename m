Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3LSWfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:35:23 -0500
Received: from smtprelay0248.hostedemail.com ([216.40.44.248]:38435 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755201Ab3LSWfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:35:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:5007:6119:7652:7901:7903:7974:10004:10400:10848:11232:11658:11914:12517:
X-HE-Tag: smile78_4b5627202da20
X-Filterd-Recvd-Size: 2409
Message-ID: <1387492517.2353.29.camel@joe-AO722>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com
Date: Thu, 19 Dec 2013 14:35:17 -0800
In-Reply-To: <20131219194213.GA824@gmail.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
	 <1387478746-5436-5-git-send-email-davidlohr@hp.com>
	 <20131219192532.GB564@gmail.com>
	 <1387481345.5494.1.camel@buesod1.americas.hpqcorp.net>
	 <20131219194213.GA824@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 20:42 +0100, Ingo Molnar wrote:
> * Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
> > On Thu, 2013-12-19 at 20:25 +0100, Ingo Molnar wrote:
> > > * Davidlohr Bueso <davidlohr@hp.com> wrote:
> > > 
> > > > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > > > Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> > > > Signed-off-by: Jason Low <jason.low2@hp.com>
> > > 
> > > So, that's not a valid SOB sequence either, the person sending me a 
> > > patch should be the last person in the SOB chain 
> > 
> > Which is why I had it like that in the original version.
> 
> The problem with that order was that the first person should be the 
> primary author and in the 'From' tag.
> 
> A SOB chain is intended to depict the true propagation/route of a 
> patch, from author, through maintainers who handle and forward it, to 
> the maintainer who applies it to a Git tree. The patch starts up with 
> a single SOB (the primary author's) and every 'hop' after that adds a 
> SOB to the tail of the existing SOB chain.

Multiple "Signed-off-by:"s are also used when there are
multiple authors of a single patch.


