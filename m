Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764086Ab3DDRmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:42:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58156 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763664Ab3DDRmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:42:20 -0400
Date: Thu, 4 Apr 2013 13:42:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>, Thomas Winischhofer <thomas@winischhofer.net>
cc: Florian Fainelli <florian@openwrt.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/5 v3] USB: regroup all depends on USB within an if USB
 block
In-Reply-To: <20130404171429.GF5129@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1304041339530.1324-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Apr 2013, Felipe Balbi wrote:

> Hi,
> 
> On Thu, Apr 04, 2013 at 05:57:24PM +0200, Florian Fainelli wrote:
> > diff --git a/drivers/usb/misc/sisusbvga/Kconfig b/drivers/usb/misc/sisusbvga/Kconfig
> > index 30ea7ca..0d03a52 100644
> > --- a/drivers/usb/misc/sisusbvga/Kconfig
> > +++ b/drivers/usb/misc/sisusbvga/Kconfig
> > @@ -1,7 +1,7 @@
> >  
> >  config USB_SISUSBVGA
> >  	tristate "USB 2.0 SVGA dongle support (Net2280/SiS315)"
> > -	depends on USB && (USB_MUSB_HDRC || USB_EHCI_HCD)
> > +	depends on (USB_MUSB_HDRC || USB_EHCI_HCD)
> 
> is it just me or would everybody agree that depending on MUSB or EHCI
> here is wrong ?

That line certainly looks like it could be removed entirely.  Perhaps 
the original author can enlighten us.

In any case, it's not relevant to the purpose of this patch set.

Alan Stern

