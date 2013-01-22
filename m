Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3AVPaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:30:13 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34891 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753383Ab3AVPaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:30:11 -0500
Date: Tue, 22 Jan 2013 10:30:10 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Shawn Guo <shawn.guo@linaro.org>
cc: Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 13/15] USB: ehci: make orion and mxc bus glues coexist
In-Reply-To: <20130122061116.GD29677@S2100-06.ap.freescale.net>
Message-ID: <Pine.LNX.4.44L0.1301221028580.1510-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013, Shawn Guo wrote:

> On Mon, Jan 21, 2013 at 09:37:42PM +0000, Arnd Bergmann wrote:
> > > Arnd, please take a look at
> > > 
> > >         http://marc.info/?l=linux-usb&amp;m=135843716515529&amp;w=2
> > > 
> > > I can't test it easily, not being set up for cross compilation.  I'm 
> > > waiting to hear from anybody whether it works before submitting it.
> > > (There's also a report of memory corruption involving a similar patch 
> > > for ehci-omap; it hasn't been tracked down yet.)
> > 
> > Your patch looks good to me, but it also seems to do some other
> > changes that are not required to fix the problem but could wait
> > for 3.9 instead. You definitely have my Ack if you are willing
> > to take it for 3.8 though.

I think it's not too late to submit this for 3.8.  Thanks for the Ack.

> > Shawn or Sascha should be able to test it.
> > 
> Alan,
> 
> Thanks for the patch.  I just gave it try.  The USB Host port still
> works for me with a couple of fixes on your changes integrated (one
> for compiling and the other for probing).  So you have my ACK with
> the changes below rolled into your patch.

Right, I have merged your changes into the patch.  Will submit shortly.

Alan Stern

