Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbaLDQMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:12:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45664 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbaLDQMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:12:06 -0500
Date: Thu, 4 Dec 2014 17:12:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        cooloney@gmail.com, rpurdie@rpsys.net, s.nawrocki@samsung.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v9 06/19] DT: Add documentation for the mfd Maxim
 max77693
Message-ID: <20141204161201.GB29080@amd>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-7-git-send-email-j.anaszewski@samsung.com>
 <20141204100706.GP14746@valkosipuli.retiisi.org.uk>
 <54804840.4030202@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54804840.4030202@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>+- maxim,boost-mode :
> >>+	In boost mode the device can produce up to 1.2A of total current
> >>+	on both outputs. The maximum current on each output is reduced
> >>+	to 625mA then. If there are two child led nodes defined then boost
> >>+	is enabled by default.
> >>+	Possible values:
> >>+		MAX77693_LED_BOOST_OFF - no boost,
> >>+		MAX77693_LED_BOOST_ADAPTIVE - adaptive mode,
> >>+		MAX77693_LED_BOOST_FIXED - fixed mode.
> >>+- maxim,boost-vout : Output voltage of the boost module in millivolts.
> >>+- maxim,vsys-min : Low input voltage level in millivolts. Flash is not fired
> >>+	if chip estimates that system voltage could drop below this level due
> >>+	to flash power consumption.
> >>+
> >>+Required properties of the LED child node:
> >>+- label : see Documentation/devicetree/bindings/leds/common.txt
> >>+- maxim,fled_id : Identifier of the fled output the led is connected to;
> >
> >I'm pretty sure this will be needed for about every chip that can drive
> >multiple LEDs. Shouldn't it be documented in the generic documentation?
> 
> OK.

Well... "fled_id" is not exactly suitable name. On other busses, it
would be "reg = <1>"?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
