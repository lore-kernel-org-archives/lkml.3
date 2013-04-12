Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3DLAWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 20:22:45 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:58240 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab3DLAWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 20:22:42 -0400
Message-ID: <516753B5.2040002@ahsoftware.de>
Date: Fri, 12 Apr 2013 02:22:13 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.4
MIME-Version: 1.0
To: balbi@ti.com
CC: Roger Quadros <rogerq@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] USB: ehci-omap: Select USB_PHY
References: <5166856C.3080906@ti.com> <20130411100435.GB14394@arwen.pp.htv.fi> <516695A4.2050804@ti.com> <20130411105557.GE14394@arwen.pp.htv.fi> <5166AFD2.4070108@ti.com> <5166B450.1000404@ahsoftware.de> <5166CC30.4060507@ti.com> <5166F3EC.8040807@ahsoftware.de> <20130411182946.GA20264@arwen.pp.htv.fi>
In-Reply-To: <20130411182946.GA20264@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.04.2013 20:29, schrieb Felipe Balbi:

> and who said OMAP USB depends on CONFIG_USB_PHY ? Some platforms need to
> control a PHY and some don't.

I've read that so.

> Go check out kernel 2.6.39 (maybe even 3.1 and 3.2) and you'll see that
> we're much better off today where we can actually have multiple PHY
> drivers and multiple UDC drivers enabled (either as modules or
> built-in), but the fact is that changing all of this over takes time and
> sometimes people make mistakes, but that's alright, since we have the
> -rc series to catch those unwanted errors.

I'll still have to stick to 3.2 because nothing afterwards boots from
EHCI on my beagleboard.

> 
> Without the help of the rest of the community, though, it'll just get
> slower and slower. With the whole single zImage effort going on in the
> ARM land, things have gotten much more critical WRT getting rid of
> "selects" and turning legacy "drivers" into real drivers, not just a
> bunch of exported functions which a single architecture uses.
> 
> Add to that all the rework going on in the Gadget Framework, PHY layer
> and EHCI drivers (which now has a core re-usable library thanks to Alan
> Stern) and you have a lot of work to do.
> 
> Next time you consider ranting about something, use that 'frustration'
> and turn it into motivation to write patches, then we all win. Also

I frequently tried and gave up. But thanks for the good suggestions.

Regards,

Alexander

