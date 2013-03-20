Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3CTXh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:37:28 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56235 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585Ab3CTXhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:37:25 -0400
X-Sasl-enc: JyL0OLC/k72TfmYTF8azx9zOeJtvaZ0aKPnS1AkW+m+p 1363822644
Date: Wed, 20 Mar 2013 16:37:23 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Meyer <thomas@m3y3r.de>, Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Imre Deak <imre.deak@intel.com>,
        Daniel Kurtz <djkurtz@chromium.org>, dri-devel@lists.freedesktop.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: [PATCH] dummy-irq: introduce a dummy IRQ handler driver (was Re:
 gm45 intel gfx can generate non-MSI irq# in MSI mode (was Re: [PATCH]
 drm/i915: stop using GMBUS IRQs on Gen4 chips (was Re: [3.9-rc1] irq 16:
 nobody cared (was [3.9-rc1] very poor interrupt respo))
Message-ID: <20130320233723.GA4156@kroah.com>
References: <Pine.LNX.4.44L0.1303201319190.1208-100000@iolanthe.rowland.org>
 <alpine.LNX.2.00.1303210018430.16237@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1303210018430.16237@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:21:21AM +0100, Jiri Kosina wrote:
> On Wed, 20 Mar 2013, Alan Stern wrote:
> 
> > > Ok, so how about this?
> > > Daniel, is it enough to make the problem appear on your system (by 
> > > building this into the kernel and booting with dummy-irq.irq=16)?
> > > 
> > > Thanks.
> > > 
> > > From: Jiri Kosina <jkosina@suse.cz>
> > > Subject: [PATCH] dummy-irq: introduce a dummy IRQ handler driver
> > > 
> > > This module accepts a single 'irq' parameter, which it should register for.
> > > 
> > > Its sole purpose is to help with debugging of IRQ sharing problems, by
> > > force-enabling IRQ that would otherwise be disabled.
> > > 
> > > Suggested-by: Alan Stern <stern@rowland.harvard.edu>
> > > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > 
> > This is just what I was thinking of.  Three extremely minor 
> > suggestions...
> 
> Thanks Alan. Updated version below.
> 
> Greg, willing to merge this simple debugging facility?

Yes, I'll take it, give me a few days to catch up with my pending queue,
don't worry, it's not lost.

greg k-h
