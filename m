Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab3CFNF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:05:59 -0500
Received: from www.linutronix.de ([62.245.132.108]:43078 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab3CFNF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:05:58 -0500
Date: Wed, 6 Mar 2013 14:05:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Simon Horman <horms@verge.net.au>
cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, benh@kernel.crashing.org,
        grant.likely@secretlab.ca
Subject: Re: [PATCH] irqchip: Renesas INTC External IRQ pin driver
In-Reply-To: <20130306114622.GE6684@verge.net.au>
Message-ID: <alpine.LFD.2.02.1303061405200.22263@ionos>
References: <20130218142834.28739.39417.sendpatchset@w520> <20130306042304.GA2896@verge.net.au> <alpine.LFD.2.02.1303061058250.22263@ionos> <20130306114622.GE6684@verge.net.au>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Mar 2013, Simon Horman wrote:

> On Wed, Mar 06, 2013 at 11:01:14AM +0100, Thomas Gleixner wrote:
> > On Wed, 6 Mar 2013, Simon Horman wrote:
> > > On Mon, Feb 18, 2013 at 11:28:34PM +0900, Magnus Damm wrote:
> > > > The SoCs using this driver are currently mainly used
> > > > together with regular platform devices so this driver
> > > > allows configuration via platform data to support things
> > > > like static interrupt base address. DT support will
> > > > be added incrementally in the not so distant future.
> > > 
> > > Hi Thomas,
> > > 
> > > I'm wondering how you would like to handle merging this driver.
> > > I can think of three options but I'm sure there are others.
> > > 
> > > * You can take the patches (there is a follow-up series) yourself.
> > > * I can prepare a pull request for you
> > > * I can prepare a pull request for arm-soc with the shmobile patches that
> > >   enable the driver on the r8a7779 and sh73a0.
> > > 
> > > The last option is possibly the easiest.
> > 
> > Correct.
> > 
> > > But in that case I'd appreciate an Ack from you on this patch.
> > 
> > You want to pick the V2 series, which already has my blessing:
> > 
> >     https://lkml.org/lkml/2013/2/26/305
> > 
> > For merging it through arm-soc you have my ack now :)
> 
> Thanks, I have that.
> 
> It seems that V2 adds onto this patch rather than replaces it.
> So could I also get an Ack for this patch too?

Ah,. right. V2 is an incremental fix for V1. Yes, please add my Ack.

Thanks,

	tglx
 
