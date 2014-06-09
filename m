Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934369AbaFIXUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:20:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932475AbaFIXT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 19:19:58 -0400
Date: Tue, 10 Jun 2014 01:19:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
cc: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org,
        Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: Re: HID: hid-sensor-hub: fix sleeping function called from invalid
 context
In-Reply-To: <5396409D.5000501@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1406100119210.2827@pobox.suse.cz>
References: <53963364.4010104@ahsoftware.de> <alpine.LNX.2.00.1406100038150.2827@pobox.suse.cz> <5396409D.5000501@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Srinivas Pandruvada wrote:

> > > while rebasing the dozens (currently around 60) of refused, ignored 
> > > or similiar bugfixes and patches I need to use a Linux kernel, I've 
> > > noticed that Jiri Kosinas patch here
> > > 
> > > https://lkml.org/lkml/2013/8/9/214
> > > 
> > > doesn't apply anymore.
> > > 
> > > Looking why, I've seen that a similiar patch from Srinivas Pandruvada
> > > named
> > > like the topic ended up in the kernel.
> > 
> > Hi Alexander,
> > 
> > thanks for drawing this one from the boulevard of forgotten patches.
> > 
> > I am actually not aware of any patch by Srinivas that would conflict with
> > the one I've written -- could you please elaborate where you believe the
> > conflict is?
> > 
> > > Looking at the differences, I wonder if not all spin_lock() calls in
> > > hid-sensor-hub.c should be changed into spin_lock_irqsave() like the
> > > patch from Jiri Kosina did.
> > 
> 
> There is a patch submitted by "reyad.attiyat@gmail.com"
> [PATCH] HID: hid-sensor-hub: Fix lockdep warning for dynamic callback locks.
> 
> Already doing this, what you suggested?

I don't see this in my mailbox at all .. so where was this submitted to, 
and who merged it to which tree?

-- 
Jiri Kosina
SUSE Labs
