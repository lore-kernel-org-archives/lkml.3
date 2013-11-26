Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab3KZVFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 16:05:12 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:13997 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932410Ab3KZVFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 16:05:08 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Vc4b+9tp1nlyPl0m+OvD9
Date: Tue, 26 Nov 2013 13:04:56 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Nishanth Menon <nm@ti.com>, balbi@ti.com, bcousson@baylibre.com,
        p.zabel@pengutronix.de, broonie@kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 09/10] ARM: dts: omap3-beagle-xm: Add USB Host
 support
Message-ID: <20131126210456.GN26766@atomide.com>
References: <1380012836-29900-1-git-send-email-rogerq@ti.com>
 <1380012836-29900-10-git-send-email-rogerq@ti.com>
 <528BD2AF.2030607@ti.com>
 <528C8FBC.7020407@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528C8FBC.7020407@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [131120 02:33]:
> Nishant,
> 
> On 11/19/2013 11:05 PM, Nishanth Menon wrote:
> > 
> > 
> > On 09/24/2013 03:53 AM, Roger Quadros wrote:
> >> Provide RESET GPIO and Power regulator for the USB PHY,
> >> the USB Host port mode and the PHY device for the controller.
> >> Also provide pin multiplexer information for USB host pins.
> >>
> >> We also relocate omap3_pmx_core pin definations so that they
> >> are close to omap3_pmx_wkup pin definations.
> >>
> >> Signed-off-by: Roger Quadros <rogerq@ti.com>
> >> ---
> > 
> > just using this thread, but a question ->
> > 
> > I am kernel * master                                   dec8e46 Merge
> > tag 'arc-v3.13-rc1-part2' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc
> > 
> > and I see that VAUX2 which supplies USB_1V8[1] is not enabled -> I did
> > a quick patch and it did seem to work (Usb keyboard, networking, mouse
> > etc on my ehci ports seems to come up good) - any suggestions how we'd
> > like to handle this?
> 
> It worked for me without your patch. It could be that u-boot is enabling
> that regulator for me. I'm on u-boot-v2013.10.
> 
> In any case, your patch seems the right thing to do. We should take it in
> the rc cycle.

Can you guys post a proper fix for this? Meanwhile, I'll mark this
thread as read to shrink my inbox a bit.

Regards,

Tony
