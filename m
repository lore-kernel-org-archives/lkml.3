Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3HBFFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 01:05:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:52527 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab3HBFFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 01:05:33 -0400
Message-ID: <1375419917.3743.93.camel@pasglop>
Subject: Re: [ANNOUNCE] 3.10.4-rt1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Sebastian Sewior <bigeasy@linutronix.de>
Date: Fri, 02 Aug 2013 15:05:17 +1000
In-Reply-To: <CAP=VYLp1ERhS4cFtgXGHL2DfCGoJ9VbPvShH5ZOWCpPuSzQY6w@mail.gmail.com>
References: <alpine.DEB.2.02.1308011215160.4089@ionos.tec.linutronix.de>
	 <CAP=VYLp1ERhS4cFtgXGHL2DfCGoJ9VbPvShH5ZOWCpPuSzQY6w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 20:03 -0400, Paul Gortmaker wrote:
> I've added Ben to the CC in case he has a suggestion on
> how best to fix this, even though it is not yet mainline.

Can you exchange with a TIF_ that isn't used in asm ? For example
TIF_PERFMON_* ? Keep all the asm ones below 16 and move up the ones
that are used in C only ?

Cheers,
Ben.


