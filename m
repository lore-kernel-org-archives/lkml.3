Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaKUSRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:17:22 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:60607 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaKUSRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:17:19 -0500
MIME-Version: 1.0
In-Reply-To: <546F5C27.7040004@ti.com>
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com>
	<1415941651-28962-4-git-send-email-vigneshr@ti.com>
	<20141118143005.GF24004@x1>
	<20141118171240.GB3003@dtor-ws>
	<546DF2F0.9080405@ti.com>
	<20141120144028.GB5809@localhost.localdomain>
	<546F2BA4.4000808@ti.com>
	<20141121131036.GA18931@localhost.localdomain>
	<CAJKbBDDVTA+=priRu7sCD=vHrC8AUg4DM3kycuGrqbpF-5FGAA@mail.gmail.com>
	<546F5C27.7040004@ti.com>
Date: Fri, 21 Nov 2014 19:17:18 +0100
Message-ID: <CAJKbBDD=eYmU=LuViwLPNV=kYCziDQgKjL07bT7og4vsj0Ee7A@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] mfd: ti_am335x_tscadc: Remove unwanted
 reg_se_cache save
From: Johannes Pointner <johannes.pointner@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Vignesh R <vigneshr@ti.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
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

Before the patches were also jumps but I thought it is something
Vignesh should know. Maybe there is some fix for that too?
As Richard also noted, it would be nice if ti could let us know how to
get the delay values right. By trial and error is IMHO not the best
way.
For the testing I used 3.16.7.


2014-11-21 16:37 GMT+01:00 Sekhar Nori <nsekhar@ti.com>:
> On Friday 21 November 2014 08:41 PM, Johannes Pointner wrote:
>> I tested version 4 of the patch series on a custom design and I saw
>> also the jumps as described by Richard. I played a little with the
>> sample delay and it got better but I couldn't completely remove the
>> jumps.
>
> And before the patches were applied, there were no jumps at all? Which
> kernel are you using for testing?
>
> Thanks,
> Sekhar
