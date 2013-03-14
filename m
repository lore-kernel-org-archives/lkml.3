Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab3CNOvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:51:04 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:50607 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755972Ab3CNOvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:51:03 -0400
Message-ID: <1363272657.1335.79.camel@x61.thuisdomein>
Subject: Re: [PATCH] usb: gadget: remove MACH_OMAP_H4_OTG
From: Paul Bolle <pebolle@tiscali.nl>
To: balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 14 Mar 2013 15:50:57 +0100
In-Reply-To: <20130314141301.GI26080@arwen.pp.htv.fi>
References: <1363032881.3137.101.camel@x61.thuisdomein>
	 <20130314141301.GI26080@arwen.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2013 14:50:57.0579 (UTC) FILETIME=[561D37B0:01CE20C3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-14 at 16:13 +0200, Felipe Balbi wrote:
> On Mon, Mar 11, 2013 at 09:14:41PM +0100, Paul Bolle wrote:
> > diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> > index 5a0c541..c65b5e2 100644
> > --- a/drivers/usb/gadget/Kconfig
> > +++ b/drivers/usb/gadget/Kconfig
> > @@ -194,7 +194,7 @@ config USB_FUSB300
> >  config USB_OMAP
> >  	tristate "OMAP USB Device Controller"
> >  	depends on ARCH_OMAP1
> > -	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_H4_OTG
> > +	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3
> 
> could you, instead, just remove the entire line ? we have an overuse of
> select and this is one of those cases where it doesn't make sense.

Sure, but there's one problem: I need to come up with a descriptive
summary. "Remove "select" because Felipe told it makes no sense" might
not be good enough. Any hint why you think this entire line can be
dropped?


Paul Bolle

