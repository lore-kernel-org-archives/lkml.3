Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaLZQfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 11:35:04 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58971 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaLZQe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 11:34:57 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/h90nVr73h5aXM2rpuATgs
Date: Fri, 26 Dec 2014 08:31:16 -0800
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org, aaro.koskinen@iki.fi,
        ivo.g.dimitrov.75@gmail.com, jdelvare@suse.de, linux@roeck-us.net,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] add omap34xx temperature monitoring support
Message-ID: <20141226163115.GA2411@atomide.com>
References: <20141226102933.GA28778@amd>
 <20141226155456.GB12409@atomide.com>
 <20141226161757.GD12409@atomide.com>
 <201412261726.35668@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412261726.35668@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [141226 08:29]:
> On Friday 26 December 2014 17:17:57 Tony Lindgren wrote:
> > > > +
> > > > +#include "../../arch/arm/mach-omap2/control.h"
> > > 
> > > No need to do this, you can use syscon here like
> > > pbias-regulator.c is doing.
> > 
> > Oh looks like you're already using syscon, nice. What defines
> > do you need from control.h?
> > 
> > Those should be in the driver if private to the driver, or
> > else we should have some minimal header in include/linux
> > somewhere if some control.h defines really need to be
> > exposed.
> > 
> > Regards,
> > 
> > Tony
> 
> Hi Tony,
> 
> Sebastian Reichel has already sent new version of temperature 
> driver. See email thread with subject:
> 
> [PATCH 0/3] OMAP3 temperature sensor

Yeah great, looks like I was also reading Sebastian's patch
with the syscon comments above :)

Regards,

Tony
