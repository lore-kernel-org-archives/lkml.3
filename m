Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbaKUPic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:38:32 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33773 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840AbaKUPi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:38:29 -0500
Message-ID: <546F5C27.7040004@ti.com>
Date: Fri, 21 Nov 2014 21:07:11 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Johannes Pointner <johannes.pointner@gmail.com>,
        Vignesh R <vigneshr@ti.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
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
        Jan Kardell <jan.kardell@telliq.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        linux-iio <linux-iio@vger.kernel.org>, <linux-input@vger.kernel.org>,
        Robert Nelson <robertcnelson@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v4 3/6] mfd: ti_am335x_tscadc: Remove unwanted reg_se_cache
 save
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com>	<1415941651-28962-4-git-send-email-vigneshr@ti.com>	<20141118143005.GF24004@x1>	<20141118171240.GB3003@dtor-ws>	<546DF2F0.9080405@ti.com>	<20141120144028.GB5809@localhost.localdomain>	<546F2BA4.4000808@ti.com>	<20141121131036.GA18931@localhost.localdomain> <CAJKbBDDVTA+=priRu7sCD=vHrC8AUg4DM3kycuGrqbpF-5FGAA@mail.gmail.com>
In-Reply-To: <CAJKbBDDVTA+=priRu7sCD=vHrC8AUg4DM3kycuGrqbpF-5FGAA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2014 08:41 PM, Johannes Pointner wrote:
> I tested version 4 of the patch series on a custom design and I saw
> also the jumps as described by Richard. I played a little with the
> sample delay and it got better but I couldn't completely remove the
> jumps.

And before the patches were applied, there were no jumps at all? Which
kernel are you using for testing?

Thanks,
Sekhar
