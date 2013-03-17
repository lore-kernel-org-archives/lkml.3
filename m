Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab3CQT51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 15:57:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37267 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab3CQT5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 15:57:25 -0400
Date: Sun, 17 Mar 2013 19:57:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: Dongsheng Song <dongsheng.song@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Linux 3.8.3
Message-ID: <20130317195709.GC4977@n2100.arm.linux.org.uk>
References: <20130314184702.GA17860@kroah.com> <CAE8XmWoYXyNFQ14e6X+2rkWQyRA=kSdc4J+DNu2Sv+6e9rvZRg@mail.gmail.com> <20130317193321.GA15102@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130317193321.GA15102@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 09:33:21PM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Sun, Mar 17, 2013 at 10:00:08PM +0800, Dongsheng Song wrote:
> > “make ARCH=arm menuconfig”  no complains,  but "make ARCH=arm
> > CROSS_COMPILE=arm-linux-gnueabihf-" failed:
> > 
> > $ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
> >   CHK     include/generated/uapi/linux/version.h
> >   CHK     include/generated/utsrelease.h
> > make[1]: `include/generated/mach-types.h' is up to date.
> >   CALL    scripts/checksyscalls.sh
> >   CHK     include/generated/compile.h
> >   CHK     kernel/config_data.h
> >   Kernel: arch/arm/boot/Image is ready
> >   Kernel: arch/arm/boot/zImage is ready
> >   Building modules, stage 2.
> >   MODPOST 1904 modules
> > ERROR: "flush_tlb_kernel_range" [drivers/staging/zsmalloc/zsmalloc.ko]
> > undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> > 
> > Please find the attachment with .config.gz file.
> 
> linux-arm-kernel might have more information about this.

Sigh.

At times, I really don't know why I bother wasting my time commenting on
patches if they just go and agree with them, and promptly ignore them.
I pointed out what this should be:

http://marc.info/?l=linux-kernel&m=135972750522902&w=2

And it was agreed:

http://marc.info/?l=linux-kernel&m=135993546317541&w=2

But for some reason the wrong patch got merged:

http://marc.info/?l=git-commits-head&m=136147889001219&w=2

Maybe because it was "simpler" ?  Don't know.  But... well, we now know
what the outcome of it was.  Let's try a different technique.  I'm going
to say nothing of any real help and hopefully it will get fixed properly.
Maybe that'll work.
