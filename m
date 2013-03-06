Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab3CFLq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:46:28 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:56761 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab3CFLq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:46:26 -0500
Date: Wed, 6 Mar 2013 20:46:22 +0900
From: Simon Horman <horms@verge.net.au>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, benh@kernel.crashing.org,
        grant.likely@secretlab.ca
Subject: Re: [PATCH] irqchip: Renesas INTC External IRQ pin driver
Message-ID: <20130306114622.GE6684@verge.net.au>
References: <20130218142834.28739.39417.sendpatchset@w520>
 <20130306042304.GA2896@verge.net.au>
 <alpine.LFD.2.02.1303061058250.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1303061058250.22263@ionos>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 11:01:14AM +0100, Thomas Gleixner wrote:
> On Wed, 6 Mar 2013, Simon Horman wrote:
> > On Mon, Feb 18, 2013 at 11:28:34PM +0900, Magnus Damm wrote:
> > > The SoCs using this driver are currently mainly used
> > > together with regular platform devices so this driver
> > > allows configuration via platform data to support things
> > > like static interrupt base address. DT support will
> > > be added incrementally in the not so distant future.
> > 
> > Hi Thomas,
> > 
> > I'm wondering how you would like to handle merging this driver.
> > I can think of three options but I'm sure there are others.
> > 
> > * You can take the patches (there is a follow-up series) yourself.
> > * I can prepare a pull request for you
> > * I can prepare a pull request for arm-soc with the shmobile patches that
> >   enable the driver on the r8a7779 and sh73a0.
> > 
> > The last option is possibly the easiest.
> 
> Correct.
> 
> > But in that case I'd appreciate an Ack from you on this patch.
> 
> You want to pick the V2 series, which already has my blessing:
> 
>     https://lkml.org/lkml/2013/2/26/305
> 
> For merging it through arm-soc you have my ack now :)

Thanks, I have that.

It seems that V2 adds onto this patch rather than replaces it.
So could I also get an Ack for this patch too?
