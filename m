Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3FMOKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 10:10:12 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:53479 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab3FMOKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 10:10:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18K/euZ41fq+UJmsqExCWgb
Date: Thu, 13 Jun 2013 07:10:01 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: Re: N900 device tree conversion: how to do first step
Message-ID: <20130613141001.GF8164@atomide.com>
References: <20130609015944.GA23559@amd.pavel.ucw.cz>
 <20130609201119.GA3190@blackmetal.musicnaut.iki.fi>
 <20130613132624.GA3464@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613132624.GA3464@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [130613 06:32]:
> Hi!
> 
> > > I'd like to convert Nokia N900 to device tree.
> > > 
> > > Unfortunately, serial port is not easily available (very special cable
> > > would be needed, does someone know where to get one?) and I don't have
> > > BDI (and very special cable would be needed, too).
> > > 
> > > So I tried doing very small first step, hoping that I get booting
> > > system... obviously I did not.
> > 
> > The following works for me, it's enough to boot and get the USB networking
> > working. After that I can connect to the device with ssh. I don't use
> > serial either, I just have initramfs with busybox+dropbear with hardcoded
> > interface setup.
> 
> Nice.... thanks a lot.
> 
> Did you get video to work with the device tree? That's what I'd like
> to accomplish now.

The DSS code is still using pdata, see mach-omap2/dss-common.[ch].
 
> If I init spi manually (and some more hacks), it works in the
> qemu. But I have not tested on real hw for a while.

You should be able to initialize spi by adding the .dts entry,
or is there something missing in drivers/spi/spi-omap2-mcspi.c?

Regards,

Tony
