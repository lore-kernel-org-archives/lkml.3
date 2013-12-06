Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab3LFTE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 14:04:56 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:43438 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab3LFTEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 14:04:53 -0500
Message-ID: <1386356686.2797.1.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dvhart@linux.intel.com,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, scott.norton@hp.com,
        tom.vaden@hp.com, aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Date: Fri, 06 Dec 2013 11:04:46 -0800
In-Reply-To: <alpine.DEB.2.02.1312061924390.30673@ionos.tec.linutronix.de>
References: <1386063927-6545-1-git-send-email-davidlohr@hp.com>
	 <1386063927-6545-5-git-send-email-davidlohr@hp.com>
	 <alpine.DEB.2.02.1312061924390.30673@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-06 at 19:26 +0100, Thomas Gleixner wrote:
> On Tue, 3 Dec 2013, Davidlohr Bueso wrote:
> > Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> > Signed-off-by: Jason Low <jason.low2@hp.com>
> > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> 
> Who is the author of this? According to the SOB chains its Waiman, who
> handed it down to Jason and it finally got sumbitted by you. Is that
> correct?

This was a group effort for the original patchset -- things did change
quite a bit for this particular patch in v2. Waiman and Jason helped
review and test the original atomic ops code.

Thanks,
Davidlohr

