Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3JVRG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:06:29 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:37099 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3JVRG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:06:27 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+/POpc6YInl1izN/ix+qfX
Date: Tue, 22 Oct 2013 10:06:04 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>, Milo Kim <milo.kim@ti.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/2] leds: lp55xx: handle enable pin in driver
Message-ID: <20131022170604.GP15154@atomide.com>
References: <1382446896-28436-1-git-send-email-sre@debian.org>
 <1382446896-28436-2-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382446896-28436-2-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@debian.org> [131022 06:02]:
> This patch moves the handling of the chip's enable pin from the board
> code into the driver. It also updates all board-code files using the
> driver to incorporate this change.
> 
> This is needed for device tree support of the enable pin.

This seems safe to merge along with the other LED patches, the
changes to arch/arm/mach-omap2 should not conflict with anything.

So for the arch/arm/mach-omap2 changes:

Acked-by: Tony Lindgren <tony@atomide.com>
