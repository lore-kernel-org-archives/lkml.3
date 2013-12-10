Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab3LJQRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:17:39 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:7867 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3LJQRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:17:37 -0500
Message-ID: <1386692253.2731.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, efault@gmx.de, jeffm@suse.com,
        torvalds@linux-foundation.org, scott.norton@hp.com, tom.vaden@hp.com,
        aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Date: Tue, 10 Dec 2013 08:17:33 -0800
In-Reply-To: <20131210153629.GA1397@gmail.com>
References: <1386063927-6545-1-git-send-email-davidlohr@hp.com>
	 <1386063927-6545-5-git-send-email-davidlohr@hp.com>
	 <alpine.DEB.2.02.1312061924390.30673@ionos.tec.linutronix.de>
	 <1386356686.2797.1.camel@buesod1.americas.hpqcorp.net>
	 <20131210153629.GA1397@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 16:36 +0100, Ingo Molnar wrote:
> * Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
> > On Fri, 2013-12-06 at 19:26 +0100, Thomas Gleixner wrote:
> > > On Tue, 3 Dec 2013, Davidlohr Bueso wrote:
> > > > Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> > > > Signed-off-by: Jason Low <jason.low2@hp.com>
> > > > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > > 
> > > Who is the author of this? According to the SOB chains its Waiman, who
> > > handed it down to Jason and it finally got sumbitted by you. Is that
> > > correct?
> > 
> > This was a group effort for the original patchset -- things did change
> > quite a bit for this particular patch in v2. Waiman and Jason helped
> > review and test the original atomic ops code.
> 
> Then please put that into the credits (in the changelog and/or in the 
> source code), and/or into copyright notices, etc. - but keep the 
> SOB-chain the true route of the patch, where the primary author is the 
> first in the SOB and where the person sending the patch is the last 
> SOB. (the two are identical normally.)

Ok, I wasn't aware of that primary author rule, sorry. The exact same
thing would go for patch 2 then. Is this something you want me to
correct for this particular series, or to keep in mind for the future?

Thanks,
Davidlohr

