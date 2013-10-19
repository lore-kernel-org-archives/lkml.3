Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab3JSVSA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 17:18:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab3JSVR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 17:17:59 -0400
Date: Sat, 19 Oct 2013 14:19:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        USB list <linux-usb@vger.kernel.org>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>, olof@lixom.net,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/2 v4] usb: ohci: remove ep93xx bus glue platform driver
Message-ID: <20131019211912.GB4453@kroah.com>
References: <201310171329.12434.hartleys@visionengravers.com>
 <Pine.LNX.4.44L0.1310171710240.2436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1310171710240.2436-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 05:11:54PM -0400, Alan Stern wrote:
> On Thu, 17 Oct 2013, H Hartley Sweeten wrote:
> 
> > Convert ep93xx to use the OHCI platform driver and remove the
> > ohci-ep93xx bus glue driver.
> > 
> > Enable CONFIG_OHCI_HCD_PLATFORM in the ep93xx_defconfig so that USB
> > is still enabled by default on the EP93xx platform.
> > 
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> > Cc: Ryan Mallon <rmallon@gmail.com>
> > Cc: Lennert Buytenhek <kernel@wantstofly.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Olof Johansson <olof@lixom.net>
> > Cc: Russell King <linux@arm.linux.org.uk>
> 
> Good work; thanks a lot for doing this.
> 
> Greg, please merge both of these v4 patches.

Will do, thanks for reviewing them.

greg k-h
