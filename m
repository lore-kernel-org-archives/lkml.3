Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab3AUS53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:57:29 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:44371 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3AUS51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:57:27 -0500
Date: Mon, 21 Jan 2013 10:57:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 12/15] USB: gadget/freescale: disable non-multiplatform
 drivers
Message-ID: <20130121185716.GA26754@kroah.com>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
 <1358788568-11137-13-git-send-email-arnd@arndb.de>
 <20130121184138.GB10106@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121184138.GB10106@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 08:41:38PM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Jan 21, 2013 at 05:16:05PM +0000, Arnd Bergmann wrote:
> > Both the fsl_mxc gadget and the imx_udc gadget drivers fail to build
> > without the mach/hardware.h file that is not available when building
> > for multiplatform. Let's disable these drivers for v3.8 in combination
> > with CONFIG_ARCH_MULTIPLATFORM, and fix them properly in v3.9 unless
> > someone has an better solution.
> > 
> > Without this patch, building allyesconfig results in:
> > 
> > drivers/usb/gadget/fsl_mxc_udc.c:21:27: fatal error: mach/hardware.h: No such file or directory
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Shawn Guo <shawn.guo@linaro.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: linux-usb@vger.kernel.org
> 
> NAK, I prefer to see a real fix for the problem (which in fact is
> already in my fixes branch).

I'll pull that branch now, sorry for the delay.

greg k-h
