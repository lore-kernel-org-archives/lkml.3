Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab3GZRLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:11:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab3GZRLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:11:39 -0400
Date: Fri, 26 Jul 2013 10:11:38 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "kernel@wantstofly.org" <kernel@wantstofly.org>
Subject: Re: [PATCH v2 0/4] usb: ohci-ep93xx: do a bit of housecleaning
Message-ID: <20130726171138.GB23444@kroah.com>
References: <201307011552.29868.hartleys@visionengravers.com>
 <ADE657CA350FB648AAC2C43247A983F0021DAC5C212C@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0021DAC5C212C@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 11:32:41AM -0500, H Hartley Sweeten wrote:
> On Monday, July 01, 2013 3:52 PM, H Hartley Sweeten wrote:
> > Tidy up this driver a bit.
> >
> > v2: redo patch 4 based on suggestions from Alan Stern
> >
> > H Hartley Sweeten (4):
> >   usb: ohci-ep93xx: use devm_ioremap_resource()
> >   usb: ohci-ep93xx: use platform_get_irq()
> >   usb: ohci-ep93xx: use devm_clk_get()
> >   usb: ohci-ep93xx: tidy up driver (*probe) and (*remove)
> >
> >  drivers/usb/host/ohci-ep93xx.c | 137 ++++++++++++++++-------------------------
> >  1 file changed, 52 insertions(+), 85 deletions(-)
> 
> All of these have been Acked-by: Alan Stern.
> 
> Any ideas when they might be picked up and applied?

Hm, what happened, I know I saw them in my todo mbox...

Ah, you didn't cc: linux-usb@, so my "let's grab all the USB patches
now" pass missed them.  Don't worry, they aren't lost, and I'll get to
them when I do my final pass of my todo mbox, I only have about 500
patches left to go, so I should finish them off today, as long as you
don't hit me with a bunch more comedi patches :)

thanks,

greg "drowning in patches" k-h
