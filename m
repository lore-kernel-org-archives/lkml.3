Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbaKUPLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:11:10 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63599 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758806AbaKUPLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:11:05 -0500
MIME-Version: 1.0
In-Reply-To: <20141121131036.GA18931@localhost.localdomain>
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com>
	<1415941651-28962-4-git-send-email-vigneshr@ti.com>
	<20141118143005.GF24004@x1>
	<20141118171240.GB3003@dtor-ws>
	<546DF2F0.9080405@ti.com>
	<20141120144028.GB5809@localhost.localdomain>
	<546F2BA4.4000808@ti.com>
	<20141121131036.GA18931@localhost.localdomain>
Date: Fri, 21 Nov 2014 16:11:02 +0100
Message-ID: <CAJKbBDDVTA+=priRu7sCD=vHrC8AUg4DM3kycuGrqbpF-5FGAA@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] mfd: ti_am335x_tscadc: Remove unwanted
 reg_se_cache save
From: Johannes Pointner <johannes.pointner@gmail.com>
To: Vignesh R <vigneshr@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-iio <linux-iio@vger.kernel.org>, linux-input@vger.kernel.org,
        Robert Nelson <robertcnelson@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested version 4 of the patch series on a custom design and I saw
also the jumps as described by Richard. I played a little with the
sample delay and it got better but I couldn't completely remove the
jumps.
The other issue I had with version 3, the pen_ups during the busy
loop, is solved. I experienced some pen_up misses during the busy loop
if I used a too high sample delay, without the sample delay it was ok.

Thanks,
Hannes

2014-11-21 14:10 GMT+01:00 Richard Cochran <richardcochran@gmail.com>:
> On Fri, Nov 21, 2014 at 05:40:12PM +0530, Sekhar Nori wrote:
>> Not sure how to reproduce the jumping on pen-up.
>
> Does the cursor stay in exactly the same spot when you lift up the
> stylus? Then you don't have the issue.
>
> On the BB white using the LCD4 cape and the shipped debian kernel, the
> cursor *does* jump away, but not as often or as far as on the custom
> design I was working with.
>
> Thanks,
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
