Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab3BEQ6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:58:20 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42064 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab3BEQ6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:58:17 -0500
Date: Tue, 5 Feb 2013 09:00:27 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Felipe Balbi <balbi@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 12/15] USB: gadget/freescale: disable non-multiplatform
 drivers
Message-ID: <20130205170027.GB1081@kroah.com>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
 <20130121184138.GB10106@arwen.pp.htv.fi>
 <20130121185716.GA26754@kroah.com>
 <201302051627.18337.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302051627.18337.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 04:27:18PM +0000, Arnd Bergmann wrote:
> On Monday 21 January 2013, Greg Kroah-Hartman wrote:
> > On Mon, Jan 21, 2013 at 08:41:38PM +0200, Felipe Balbi wrote:
> > > Hi,
> > > 
> > > On Mon, Jan 21, 2013 at 05:16:05PM +0000, Arnd Bergmann wrote:
> > > > Both the fsl_mxc gadget and the imx_udc gadget drivers fail to build
> > > > without the mach/hardware.h file that is not available when building
> > > > for multiplatform. Let's disable these drivers for v3.8 in combination
> > > > with CONFIG_ARCH_MULTIPLATFORM, and fix them properly in v3.9 unless
> > > > someone has an better solution.
> > > > 
> > > > Without this patch, building allyesconfig results in:
> > > > 
> > > > drivers/usb/gadget/fsl_mxc_udc.c:21:27: fatal error: mach/hardware.h: No such file or directory
> > > > 
> > > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > > Cc: Felipe Balbi <balbi@ti.com>
> > > > Cc: Shawn Guo <shawn.guo@linaro.org>
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Cc: linux-usb@vger.kernel.org
> > > 
> > > NAK, I prefer to see a real fix for the problem (which in fact is
> > > already in my fixes branch).
> > 
> > I'll pull that branch now, sorry for the delay.
> 
> Apparently it hasn't made it into the upstream kernel yet, and it also doesn't
> seem to be in linux-next. Maybe this got lost while you were travelling?

Hm, no, I thought I got Felipe's fixes branch up into Linus's tree
already.  Felipe, did I miss something from you?  If so, please resend
or let me know, as I don't have anything pending on my side.

thanks,

greg k-h
