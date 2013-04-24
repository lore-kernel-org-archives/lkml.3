Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab3DXVRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 17:17:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47612 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758073Ab3DXVRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 17:17:42 -0400
Date: Wed, 24 Apr 2013 17:17:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sedat Dilek <sedat.dilek@gmail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-usb@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 24 [ PM: Device 1-1.2 failed to resume
 async: error -32 ]
In-Reply-To: <CA+icZUVkRCavG-gs6r2x_kyZe_Mm8WLewp-zpKn=f3GWU+jJZw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1304241715170.1548-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013, Sedat Dilek wrote:

> > Did this work differently under earlier kernels?
> >
> 
> Unfortunately, s/r did not work for several Linux-Next releases as
> there is missing tglx's patch pendinging in tip.git/timers/core.

Have you tried testing under 3.8?  Or earlier releases?

> > This indicates that the optical mouse didn't survive the suspend/resume
> > sequence and had to be reenumerated.  Without more information, there's
> > no way to tell specifically what went wrong during the initial reset at
> > timestamp 62.353997.
> >
> > If you want to pursue this farther, you could enable CONFIG_USB_DEBUG.
> > You could also collect a usbmon trace for bus 1 showing what happens
> > during the suspend and resume.
> >
> 
> Hmm, I can try to enable CONFIG_USB_DEBUG and build a new kernel.
> 
> Can you give me more hints how to do a usbmon-trace?

See Documentation/usb/usbmon.txt.

> > On the other hand, what difference does it really make if a mouse has
> > to be reenumerated?
> >
> 
> As a non-USB-expert it's hard to interprete such "bogus" lines in your logs.
> I am curious enough to ask which is fair :-).
> AFAICS in your eyes this is "harmless"?

If the device continues to work normally after the resume and none of
your programs are affected, then it is harmless.

Alan Stern

