Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbaELVH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:07:59 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36299 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300AbaELVH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:07:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19MambLHLL7qvKwBXaoeemH
Date: Mon, 12 May 2014 14:07:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Robert Nelson <robertcnelson@gmail.com>
Cc: Tom Rini <trini@ti.com>, Matt Ranostay <mranostay@gmail.com>,
        robh+dt@kernel.org, mark.rutland@arm.com,
        Russell King <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Matt Porter <matt.porter@linaro.org>
Subject: Re: [PATCH v2] ARM: dts: am335x-bone-common: Add i2c2 definition
Message-ID: <20140512210747.GE5668@atomide.com>
References: <1399686184-1594-1-git-send-email-mranostay@gmail.com>
 <20140512195050.GB5668@atomide.com>
 <CAOCHtYiYwx_bEsyqkbUTTAbhBYESzvfBOOYeVuFXPS1dDy0ZKA@mail.gmail.com>
 <20140512201517.GC5668@atomide.com>
 <CAOCHtYg6XpF0Gbo4iFqsFvP=QSivQQvCzov8UfxeLXMzrRYEWw@mail.gmail.com>
 <20140512204213.GD5668@atomide.com>
 <CAOCHtYgg7jwxswH+mqF3RA7-0RP-nGuft+Ze-GRwu1fbA6+0Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOCHtYgg7jwxswH+mqF3RA7-0RP-nGuft+Ze-GRwu1fbA6+0Bw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Robert Nelson <robertcnelson@gmail.com> [140512 13:58]:
> >> Either case if fine with me.  As who knows when the dtc "overlay" will
> >> every truly make it mainline, as the capemgr was the only real kernel
> >> user of the i2c/at24 eeprom information.
> >
> > Sounds like we should keep it disabled though so u-boot can be used
> > to toggle it while waiting for the capemgr. That's because the board
> > has a header for pins, so it's not exactly limited to just the capes.
> >
> > Anybody working on enabling/disabling cape dtb configurations in u-boot?
> 
> Well,
> 
> Would Tom even approve of that in mainline u-boot? He didn't want my
> "invert" the gpio to enable the usb hub on the older beagle xm A/B..
> 
> http://lists.denx.de/pipermail/u-boot/2014-January/172154.html
> 
> http://lists.denx.de/pipermail/u-boot/2014-January/172274.html

Right, no idea. But until we have some way to actually use the capes
without conflicting dts entries, I can't merge them.

Regards,

Tony
