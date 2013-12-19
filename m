Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3LSTmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:42:18 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:63359 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3LSTmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:42:17 -0500
Date: Thu, 19 Dec 2013 20:42:13 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, dvhart@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        efault@gmx.de, jeffm@suse.com, torvalds@linux-foundation.org,
        jason.low2@hp.com, Waiman.Long@hp.com, tom.vaden@hp.com,
        scott.norton@hp.com, aswin@hp.com
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
Message-ID: <20131219194213.GA824@gmail.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
 <1387478746-5436-5-git-send-email-davidlohr@hp.com>
 <20131219192532.GB564@gmail.com>
 <1387481345.5494.1.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387481345.5494.1.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davidlohr Bueso <davidlohr@hp.com> wrote:

> On Thu, 2013-12-19 at 20:25 +0100, Ingo Molnar wrote:
> > * Davidlohr Bueso <davidlohr@hp.com> wrote:
> > 
> > > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > > Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> > > Signed-off-by: Jason Low <jason.low2@hp.com>
> > 
> > So, that's not a valid SOB sequence either, the person sending me a 
> > patch should be the last person in the SOB chain 
> 
> Which is why I had it like that in the original version.

The problem with that order was that the first person should be the 
primary author and in the 'From' tag.

A SOB chain is intended to depict the true propagation/route of a 
patch, from author, through maintainers who handle and forward it, to 
the maintainer who applies it to a Git tree. The patch starts up with 
a single SOB (the primary author's) and every 'hop' after that adds a 
SOB to the tail of the existing SOB chain.

> > - if you want to 
> > credit them please add a Reviewed-by or add special credits to the 
> > changelog.
> 
> I will change the tags and resend in a v4.

Thanks,

	Ingo
