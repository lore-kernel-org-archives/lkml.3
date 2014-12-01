Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbaLANCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:02:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49878 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaLANCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:02:34 -0500
Date: Mon, 1 Dec 2014 14:02:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
        sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v8 11/14] DT: Add documentation for the mfd Maxim
 max77693
Message-ID: <20141201130231.GA24737@amd>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-12-git-send-email-j.anaszewski@samsung.com>
 <20141129192607.GB17355@amd>
 <547C65F7.4090801@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547C65F7.4090801@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Is this one needed? Just ommit child note if it is not there.
> 
> It is needed because you can have one led connected two both
> outputs. This allows to describe such a design.

Ok.

> >>+- maxim,trigger-type : Array of trigger types in order: flash, torch
> >>+	Possible trigger types:
> >>+		0 - Rising edge of the signal triggers the flash/torch,
> >>+		1 - Signal level controls duration of the flash/torch.
> >>+- maxim,trigger : Array of flags indicating which trigger can activate given led
> >>+	in order: fled1, fled2
> >>+	Possible flag values (can be combined):
> >>+		1 - FLASH pin of the chip,
> >>+		2 - TORCH pin of the chip,
> >>+		4 - software via I2C command.
> >
> >Is it good idea to have bitfields like this?
> >
> >Make these required properties of the subnode?
> 
> This is related to a single property: trigger. I think that splitting
> it to three properties would make unnecessary noise in the
> binding.

Well, maybe it is not that much noise, and you'll have useful names
(not a bitfield).

Should these properties move to the LED subnode?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
