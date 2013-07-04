Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852Ab3GDUdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 16:33:09 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:44337 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789Ab3GDUdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 16:33:05 -0400
Date: Thu, 4 Jul 2013 23:32:56 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tony Lindgren <tony@atomide.com>, b-cousson@ti.com, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] N900: add device tree
Message-ID: <20130704203256.GB27374@blackmetal.musicnaut.iki.fi>
References: <20130613145724.GH8164@atomide.com>
 <20130613155240.GB3775@amd.pavel.ucw.cz>
 <20130613161418.GJ8164@atomide.com>
 <20130613230808.GA14876@amd.pavel.ucw.cz>
 <20130614055629.GM8164@atomide.com>
 <20130614212816.GA31768@atrey.karlin.mff.cuni.cz>
 <20130617111031.GQ20992@atomide.com>
 <20130701211753.GC15318@amd.pavel.ucw.cz>
 <20130704171939.GA27374@blackmetal.musicnaut.iki.fi>
 <20130704202145.GB10752@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130704202145.GB10752@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 04, 2013 at 10:21:45PM +0200, Pavel Machek wrote:
> > > This adds device tree with neccessary support to boot with functional
> > > video (on both emulator and real N900 device).
> > 
> > Is this really correct? You have commented out the USB, so there is no
> > way for a developer to interact with the device.
> 
> Well... I do not have USB & SDcard set up, so my testing was "does it
> show failed to mount root message on screen". 
> 
> Now, if I do quick test of enabling it on 3.9, I get:
> 
>   DTC     arch/arm/boot/dts/omap3-n900.dtb
> Error: arch/arm/boot/dts/omap3-n900.dts:92.2-3 label or path,
> 'usb_otg_hs', not found
> FATAL ERROR: Syntax error parsing input tree
> make[1]: *** [arch/arm/boot/dts/omap3-n900.dtb] Error 1
> make: *** [dtbs] Error 2

You need 3.10. It was added in ad871c10b55654910ba97af00a00e65725da5e40
(ARM: dts: OMAP: Add usb_otg and glue data to OMAP3+ boards).

3.9 is very old. :-)

> If you could test the patches with the USB support uncommented, that
> would be very good...

I can do that, but not before next week.

A.
