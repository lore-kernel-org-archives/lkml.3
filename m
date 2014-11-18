Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaKRIuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:50:19 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44178 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaKRIuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:50:15 -0500
Date: Tue, 18 Nov 2014 09:50:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Message-ID: <20141118085013.GD4059@amd>
References: <20141116075928.GA9763@amd>
 <20141117145857.GO8907@valkosipuli.retiisi.org.uk>
 <546AFEA5.9020000@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546AFEA5.9020000@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-18 09:09:09, Jacek Anaszewski wrote:
> Hi Pavel, Sakari,
> 
> On 11/17/2014 03:58 PM, Sakari Ailus wrote:
> >Hi Pavel,
> >
> >On Sun, Nov 16, 2014 at 08:59:28AM +0100, Pavel Machek wrote:
> >>For device tree people: Yes, I know I'll have to create file in
> >>documentation, but does the binding below look acceptable?
> >>
> >>I'll clean up driver code a bit more, remove the printks. Anything
> >>else obviously wrong?
> >
> >Jacek Anaszewski is working on flash support for LED devices. I think it'd
> >be good to sync the DT bindings for the two, as the types of devices
> >supported by the LED API and the V4L2 flash API are quite similar.
> >
> >Cc Jacek.
> 
> I've already submitted a patch [1] that updates leds common bindings.
> I hasn't been merged yet, as the related LED Flash class patch [2]
> still needs some indicator leds related discussion [3].
> 
> I think this is a good moment to discuss the flash related led common
> bindings.
> 
> [2] http://www.spinics.net/lists/linux-media/msg83100.html

Actually, would it be possible to do the patches the other way around?

V4L2 api already knows about flash, torch and indicators. Provide
glue, so that V4L2 torch automatically appears as two leds in the led
subystem? (white and red in my case?)

[Well, I kind of like the LED class API more, but it appears both you
and me really have two LEDs in one package, and V4L2 already knows
about that so it is better match....?]

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
