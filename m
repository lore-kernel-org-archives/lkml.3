Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbbAOVDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:03:20 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45193 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbbAOVDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:03:15 -0500
Date: Thu, 15 Jan 2015 22:03:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Rob Herring <robherring2@gmail.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        linux-leds@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        sakari.ailus@iki.fi, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH/RFC v10 03/19] DT: leds: Add led-sources property
Message-ID: <20150115210310.GB24008@amd>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-4-git-send-email-j.anaszewski@samsung.com>
 <CAL_JsqJKEp6TWaRhJimg3AWBh+MCCr2Bk9+1o7orLLdp5E+n-g@mail.gmail.com>
 <54B38682.5080605@samsung.com>
 <CAL_Jsq+UaA41DvawdOMmOib=Fi0hC-nBdKV-+P4DFo+MoOy-bQ@mail.gmail.com>
 <54B3F1EF.4060506@samsung.com>
 <CAL_JsqKpJtUG0G6g1GOuSVpc31oe-dp3qdrKJUE0upG-xRDFhA@mail.gmail.com>
 <20150112170644.GO4160@sirena.org.uk>
 <54B7B39C.7080204@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B7B39C.7080204@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Perhaps we could use the 'reg' property to describe actual connections,
> I'm not sure if it's better than a LED specific property, e.g.
> 
> max77387@52 {
>         compatible = "nxp,max77387";
>         #address-cells = <2>;
>         #size-cells = <0>;
>         reg = <0x52>;
> 
> 	flash_led {
> 		reg = <1 1>;	
> 		...
> 	};	
> };

Normally, reg property is <start length>, if I understand things
correctly? Would that be enough here, or would we be doing list of
outputs?

Thanks,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
