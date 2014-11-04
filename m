Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaKDISh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:18:37 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:61266 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaKDISf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:18:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kevin Cernekee <cernekee@gmail.com>, f.fainelli@gmail.com,
        jason@lakedaemon.net, ralf@linux-mips.org, linux-sh@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH V3 00/14] genirq endian fixes; bcm7120/brcmstb IRQ updates
Date: Tue, 04 Nov 2014 09:18:17 +0100
Message-ID: <2690630.v59x1FdWZd@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1411032117050.5308@nanos>
References: <1414890241-9938-1-git-send-email-cernekee@gmail.com> <2217077.1aQXS9nJph@wuerfel> <alpine.DEB.2.11.1411032117050.5308@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:wwz9ruhg09eCzhx+CA4vvIu0xojgAcFEciki6eN1xBu
 Hi32iUwzlA9Y0LBKkG4hpU8xiLRBavTBwiv9bG6Z6ShlCq7JiH
 2eGxCOvN+fp+JN403pvpN8FjwVps0fQ3KX6GkmszGX81ExNMKO
 SaAhreqp1YYJPEw7dpygTknvkm37R7Rc7ddVBpWr7SvwM/YvAC
 3fA0bpDdceurnbD/5nN6CJEhrEFejvlzLdtm2ZXWN7S0aAn1Of
 RP6ZvRi035tN2l/QGzYY7PMykxZMj/naRgpDjC/+bRZEHQdnMp
 jrqsZRoWjLRLBcmzHEddaghOOVGyLtNUGXFShWP8rpCCCjuHNT
 OPiVCH28H/kTL/sD/mis=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 November 2014 21:18:20 Thomas Gleixner wrote:
> On Mon, 3 Nov 2014, Arnd Bergmann wrote:
> > On Saturday 01 November 2014 18:03:47 Kevin Cernekee wrote:
> > > V2->V3:
> > > 
> > >  - Move updated irq_reg_{readl,writel} functions back into <linux/irq.h>
> > >    so they can be called by irqchip drivers
> > > 
> > >  - Add gc->reg_{readl,writel} function pointers so that irqchip
> > >    drivers like arch/sh/boards/mach-se/{7343,7722}/irq.c can override them
> > > 
> > >  - CC: linux-sh list in lieu of Paul's defunct linux-sh.org email address
> > > 
> > >  - Fix handling of zero L2 status in bcm7120-l2.c
> > > 
> > >  - Rebase on Linus' head of tree
> > 
> > Looks all great. I also looked at the series now and am very happy
> > about how it turned out.
> 
> Does that translate to an Acked-by on the whole lot?
> 
> Jason, can you please pick that lot up with an Acked-by-me on the
> changes to the existing infrastructure?

Yes, I should have been more explicit:

Acked-by: Arnd Bergmann <arnd@arndb.de>
