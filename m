Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbaKTMMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:12:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33679 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaKTMMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:12:06 -0500
Date: Thu, 20 Nov 2014 13:12:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Message-ID: <20141120121202.GA27527@amd>
References: <20141117145857.GO8907@valkosipuli.retiisi.org.uk>
 <546AFEA5.9020000@samsung.com>
 <20141118084603.GC4059@amd>
 <546B19C8.2090008@samsung.com>
 <20141118113256.GA10022@amd>
 <546B40FA.2070409@samsung.com>
 <20141118132159.GA21089@amd>
 <546B6D86.8090701@samsung.com>
 <20141118165148.GA11711@amd>
 <546C66A5.6060201@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546C66A5.6060201@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I would also swap the segments of a property name to follow the convention
> as in case of "regulator-max-microamp".
> 
> Updated version:
> 
> ==========================================================
> 
> Optional properties for child nodes:
> - max-microamp : maximum intensity in microamperes of the LED
> 		 (torch LED for flash devices)
> - flash-max-microamp : maximum intensity in microamperes of the
> 		       flash LED; it is mandatory if the led should
> 		       support the flash mode
> - flash-timeout-microsec : timeout in microseconds after which the flash
> 		           led is turned off

Works for me. Do you want to submit a patch or should I do it?

> - indicator-pattern : identifier of the blinking pattern for the
> 		      indicator led
> 

This would need a bit more documentation, no?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
