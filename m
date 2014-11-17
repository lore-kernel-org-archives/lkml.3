Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaKQPGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:06:52 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56265 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaKQPGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:06:50 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/00kWUH9GJBMwGj6Qb+82Z
Date: Mon, 17 Nov 2014 07:06:17 -0800
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org, aaro.koskinen@iki.fi,
        freemangordon@abv.bg, bcousson@baylibre.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sakari.ailus@iki.fi, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Message-ID: <20141117150617.GD7046@atomide.com>
References: <20141116075928.GA9763@amd>
 <20141117101553.GA21151@amd>
 <20141117145545.GC7046@atomide.com>
 <201411171601.32311@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201411171601.32311@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [141117 07:03]:
> On Monday 17 November 2014 15:55:46 Tony Lindgren wrote:
> > 
> > There's nothing stopping us from initializing the camera code
> > from pdata-quirks.c for now to keep it working. Certainly the
> > binding should be added to the driver, but that removes a
> > dependency to the legacy booting mode if things are otherwise
> > working.
> 
> Tony, legacy board code for n900 is not in mainline tree. And 
> that omap3 camera subsystem for n900 is broken since 3.5 
> kernel... (both Front and Back camera on n900 show only green 
> picture).

I'm still seeing the legacy board code for n900 in mainline tree :)
It's deprecated, but still there.

Are you maybe talking about some other piece of platform_data that's
no longer in the mainline kernel?

No idea what might be wrong with the camera though.

Regards,

Tony
