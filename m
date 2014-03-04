Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaCDX3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:29:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:37935 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbaCDX3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:29:16 -0500
Date: Wed, 5 Mar 2014 00:29:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        peterz@infradead.org, linuxppc-dev@lists.ozlabs.org,
        shangw@linux.vnet.ibm.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] powerpc: eeh: Fixup the brown paperbag fallout
 of the "cleanup"
In-Reply-To: <1393975112.10727.103.camel@pasglop>
Message-ID: <alpine.DEB.2.02.1403050027560.18573@ionos.tec.linutronix.de>
References: <tip-57310c3c99eb6fab2ecbd63aa3f7c323341ca77e@git.kernel.org> <1393975112.10727.103.camel@pasglop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Benjamin Herrenschmidt wrote:

> On Tue, 2014-03-04 at 15:15 -0800, tip-bot for Thomas Gleixner wrote:
> > Commit-ID:  57310c3c99eb6fab2ecbd63aa3f7c323341ca77e
> > Gitweb:     http://git.kernel.org/tip/57310c3c99eb6fab2ecbd63aa3f7c323341ca77e
> > Author:     Thomas Gleixner <tglx@linutronix.de>
> > AuthorDate: Wed, 5 Mar 2014 00:06:11 +0100
> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Wed, 5 Mar 2014 00:13:33 +0100
> > 
> > powerpc: eeh: Fixup the brown paperbag fallout of the "cleanup"
> > 
> > Commit b8a9a11b9 (powerpc: eeh: Kill another abuse of irq_desc) is
> > missing some brackets .....
> > 
> > It's not a good idea to write patches in grumpy mode and then forget
> > to at least compile test them or rely on the few eyeballs discussing
> > that patch to spot it.....
> 
> Ouch :-)
> 
> Next time you have a series like that, if you want I'll throw it at my
> build tester.

You simply could have been less lazy and picked up the whole ppc
related stuff instead of ignoring it....

Thanks,

	tglx
