Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaCGRRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:17:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:40037 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbaCGRRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:17:09 -0500
Date: Fri, 7 Mar 2014 18:17:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
cc: Jason Cooper <jason@lakedaemon.net>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 5/5] irqchip: armanda: Sanitize set_irq_affinity()
In-Reply-To: <5319ED86.2050707@free-electrons.com>
Message-ID: <alpine.DEB.2.02.1403071816340.18573@ionos.tec.linutronix.de>
References: <20140304202425.102779779@linutronix.de> <20140304203101.088889302@linutronix.de> <20140306190531.GF1872@titan.lakedaemon.net> <5319ED86.2050707@free-electrons.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2014, Gregory CLEMENT wrote:

> On 06/03/2014 20:05, Jason Cooper wrote:
> > Thomas,
> > 
> > nit: s/armanda/armada/ in the patch subject.
> > 
> > Gregory,
> > 
> > Mind providing an Ack on this?
> 
> Well sorry but with this patch the kernel doesn't
> work anymore.
> 
> I am investigating to find if some part could be kept.

It might be the readback of the routing register. I don't have the
datasheet of this.
 
Thanks,

	tglx
