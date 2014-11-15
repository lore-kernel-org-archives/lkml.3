Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaKOT1u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 14:27:50 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:46022 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbaKOT1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 14:27:47 -0500
Date: Sat, 15 Nov 2014 20:27:39 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Vignesh R <vigneshr@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v4 2/6] input: touchscreen: ti_am335x_tsc: Remove udelay
 in interrupt handler
Message-ID: <20141115192739.GA18766@localhost.localdomain>
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com>
 <1415941651-28962-3-git-send-email-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415941651-28962-3-git-send-email-vigneshr@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 10:37:27AM +0530, Vignesh R wrote:
> From: Brad Griffis <bgriffis@ti.com>
> 
> TSC interrupt handler had udelay to avoid reporting of false pen-up
> interrupt to user space. This patch implements workaround suggesting in
> Advisory 1.0.31 of silicon errata for am335x, thus eliminating udelay
> and touchscreen lag. This also improves performance of touchscreen and
> eliminates sudden jump of cursor at touch release.

I back ported this series onto v3.15.1 in order to try this out on a
custom, beaglebone-like board. With this series, the touch is really
broken. (I had fixed the pen up problem in a totally different way for
a customer, and so I wanted to try out your solution.)

I will try to port the board code to a more recent kernel to try your
series again. With which kernel version did you test your patches?

And which board?

Thanks,
Richard


