Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbaCEA1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:27:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:38226 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbaCEA1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:27:16 -0500
Date: Wed, 5 Mar 2014 01:27:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] irq-gic: remove file name from heading comment
In-Reply-To: <53166B67.2060804@cogentembedded.com>
Message-ID: <alpine.DEB.2.02.1403050112180.18573@ionos.tec.linutronix.de>
References: <201312140224.53928.sergei.shtylyov@cogentembedded.com> <52D5CCFB.1090205@cogentembedded.com> <53166B67.2060804@cogentembedded.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Sergei Shtylyov wrote:
> Hello.
> 
> On 01/15/2014 02:49 AM, Sergei Shtylyov wrote:
> 
> > > File names in the heading comments  fell out of favor long ago, and this
> > > one
> > > weren't even changed when the driver was moved from arch/arm/common/, so
> > > remove
> > > it at last...
> 
> > > Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> > > ---
> > > The patch is against the 'irq/core' branch of the 'tip.git' repo.
> 
> >     Thomas, is there a chance that you merge this patch for 3.14? Is it even
> > the right branch for cleanups (I'm seeing fixes there)?
> 
>    Thomas, will you ever reply to me? Who's maintaining the GIC driver, you?
> Or the patches shoud just go in via arm-soc.git?

That patch is so important^Wtrivial that it really can go via the
obvious trivial@kernel.org

Sigh....
