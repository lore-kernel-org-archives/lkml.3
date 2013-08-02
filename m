Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3HBVV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:21:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:51848 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab3HBVV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:21:27 -0400
Message-ID: <1375478457.15999.25.camel@pasglop>
Subject: Re: [ANNOUNCE] 3.10.4-rt1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Sat, 03 Aug 2013 07:20:57 +1000
In-Reply-To: <20130802141936.GA8267@windriver.com>
References: <alpine.DEB.2.02.1308011215160.4089@ionos.tec.linutronix.de>
	 <CAP=VYLp1ERhS4cFtgXGHL2DfCGoJ9VbPvShH5ZOWCpPuSzQY6w@mail.gmail.com>
	 <1375419917.3743.93.camel@pasglop> <51FBA9CC.2090206@linutronix.de>
	 <20130802141936.GA8267@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 10:19 -0400, Paul Gortmaker wrote:
> 
> Yep, 3.8 shuffled TIF_MEMDIE to the end of the queue, but
> in 3.10, mainline commit 22ecbe8dcef has already done that trick.
> 
> The list of donor victims that aren't used in asm is getting
> smaller, but TIF_POLLING_NRFLAG seems OK and it puts RESCHED
> and RESCHED_LAZY right beside each other.

Worst case we can turn it into a 32-bit and but I'd rather avoid it
as long as we can :-)

Cheers,
Ben.


