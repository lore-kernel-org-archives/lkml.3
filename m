Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934837Ab3GWWsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:48:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934593Ab3GWWsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:48:40 -0400
Date: Tue, 23 Jul 2013 15:48:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Moiz Sonasath <m-sonasath@ti.com>
Subject: Re: [PATCH] usb: fix build warning in pci-quirks.h when CONFIG_PCI
 is not enabled
Message-ID: <20130723224838.GA4456@kroah.com>
References: <51EF0243.1000007@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EF0243.1000007@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 03:22:59PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix warning when CONFIG_PCI is not enabled
> (from commit 296365781903226a3fb8758901eaeec09d2798e4).
> 
> drivers/usb/host/pci-quirks.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Moiz Sonasath <m-sonasath@ti.com>
> ---
>  drivers/usb/host/pci-quirks.h |    1 +

$ ./scripts/get_maintainer.pl --file drivers/usb/host/pci-quirks.h
Sarah Sharp <sarah.a.sharp@linux.intel.com> (supporter:USB XHCI DRIVER)
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:USB SUBSYSTEM)
linux-usb@vger.kernel.org (open list:USB XHCI DRIVER)
linux-kernel@vger.kernel.org (open list)

Sarah should get this patch, thanks.

greg k-h
