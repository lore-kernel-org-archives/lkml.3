Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3JSVU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 17:20:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3JSVU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 17:20:57 -0400
Date: Sat, 19 Oct 2013 14:22:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-usb@vger.kernel.org,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>, stern@rowland.harvard.edu,
        Lennert Buytenhek <buytenh@wantstofly.org>, olof@lixom.net,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/2 v4] usb: ohci: remove ep93xx bus glue platform driver
Message-ID: <20131019212213.GA5341@kroah.com>
References: <201310171329.12434.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201310171329.12434.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 01:29:11PM -0700, H Hartley Sweeten wrote:
> Convert ep93xx to use the OHCI platform driver and remove the
> ohci-ep93xx bus glue driver.
> 
> Enable CONFIG_OHCI_HCD_PLATFORM in the ep93xx_defconfig so that USB
> is still enabled by default on the EP93xx platform.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Lennert Buytenhek <kernel@wantstofly.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Russell King <linux@arm.linux.org.uk>
> ---
>  arch/arm/configs/ep93xx_defconfig |   1 +
>  arch/arm/mach-ep93xx/clock.c      |   2 +-
>  arch/arm/mach-ep93xx/core.c       |  38 +++++++-
>  drivers/usb/host/ohci-ep93xx.c    | 184 --------------------------------------
>  drivers/usb/host/ohci-hcd.c       |  18 ----
>  5 files changed, 36 insertions(+), 207 deletions(-)
>  delete mode 100644 drivers/usb/host/ohci-ep93xx.c

This patch doesn't apply to my usb-next branch of usb.git at all, what
happened?  Did Alan's other recent changes interfere with this?

Can you refresh this against my tree and resend it so that I can apply
it?  I've applied the 1/2 patch already.

thanks,

greg k-h
