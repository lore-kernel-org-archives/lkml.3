Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3CaTzX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 15:55:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab3CaTzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 15:55:22 -0400
Date: Sun, 31 Mar 2013 21:55:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
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
Subject: Re: [PATCH] dummy-irq: introduce a dummy IRQ handler driver (was
 Re: gm45 intel gfx can generate non-MSI irq# in MSI mode (was Re: [PATCH]
 drm/i915: stop using GMBUS IRQs on Gen4 chips (was Re: [3.9-rc1] irq 16:
 nobody cared (was [3.9-rc1] very poor interrupt respo))
In-Reply-To: <20130321144526.GR9021@phenom.ffwll.local>
Message-ID: <alpine.LNX.2.00.1303312153520.22069@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1303201319190.1208-100000@iolanthe.rowland.org> <alpine.LNX.2.00.1303210018430.16237@pobox.suse.cz> <20130321144526.GR9021@phenom.ffwll.local>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013, Daniel Vetter wrote:

> Indeed, this is pretty useful and allowed me to quickly reproduce that
> phantom irq on my gm45. Thanks to module reloading we can even reset the
> kernel's irq disabling logic and so test different tricks quickly without
> rebooting. Really useful.

Daniel,

out of curiosity, have you been able to make some sense of the phantom 
legacy IRQs on GM45 systems, or are we just staying with my original 
bandaid (disabling GMBUS IRQs), declaring GM45 broken in this respect?

Thanks,

-- 
Jiri Kosina
SUSE Labs
