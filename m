Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab3A2Pe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:34:56 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36685 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756720Ab3A2Pey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:34:54 -0500
Date: Tue, 29 Jan 2013 10:34:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 09/30] USB: ehci-omap: Use devm_request_and_ioremap()
In-Reply-To: <20130128152010.GN23505@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.44L0.1301291033000.1507-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Russell King - ARM Linux wrote:

> On Mon, Jan 28, 2013 at 10:17:33AM -0500, Alan Stern wrote:
> > On Mon, 28 Jan 2013, Roger Quadros wrote:
> > 
> > > Make use of devm_request_and_ioremap() and correct comment.
> > 
> > Didn't a big patch come through recently converting all usages of 
> > devm_request_and_ioremap() to another function (I forget the name) that 
> > does its own error reporting and returns an ERR_PTR value?
> > 
> > (Checks the mailing list archive...)  Ah, here it is:
> > 
> > 	http://marc.info/?l=linux-usb&m=135876311801537&w=2
> > 
> > And the new function is devm_ioremap_resource().  We should avoid 
> > adding new usages of an old interface.
> 
> Maybe... if devm_ioremap_resource() was already in the kernel.  The
> problem at the moment is it isn't, and it'll probably be rather
> horrid for everyone to deal with especially when it comes to testing.

Not in the kernel yet?  I didn't realize that.  Looks like Thierry 
Reding will have some clean-up work to do when it does get in.

Okay, then

Acked-by: Alan Stern <stern@rowland.harvard.edu>

