Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988AbaD1T3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:29:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:42190 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948AbaD1T2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:28:50 -0400
Date: Mon, 28 Apr 2014 21:05:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Cooper <jason@lakedaemon.net>
cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 5/5] irqchip: armanda: Sanitize set_irq_affinity()
In-Reply-To: <20140425111539.GC28159@titan.lakedaemon.net>
Message-ID: <alpine.DEB.2.02.1404282105110.6261@ionos.tec.linutronix.de>
References: <20140304202425.102779779@linutronix.de> <20140304203101.088889302@linutronix.de> <20140306190531.GF1872@titan.lakedaemon.net> <5319ED86.2050707@free-electrons.com> <alpine.DEB.2.02.1403071816340.18573@ionos.tec.linutronix.de>
 <53285303.8000305@free-electrons.com> <alpine.DEB.2.02.1403182153330.18573@ionos.tec.linutronix.de> <5328B4C9.6020906@free-electrons.com> <53593619.2000107@free-electrons.com> <20140425111539.GC28159@titan.lakedaemon.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2014, Jason Cooper wrote:
> On Thu, Apr 24, 2014 at 06:04:41PM +0200, Gregory CLEMENT wrote:
> > 
> > I have just noticed that this patch was not merged in 3.15.
> > Actually it is not in the core/irq branch of tip.git with
> > the other patches of the same series.
> > Is there any reason for this?
> 
> I know your mail filters are pretty aggressive and I just wanted to make
> sure you saw this.  I'm also not sure what happened here.

Dunno, must have fallen through the cracks. Lemme find it again.
