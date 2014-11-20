Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbaKTOki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:40:38 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:42942 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbaKTOkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:40:35 -0500
Date: Thu, 20 Nov 2014 15:40:28 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Vignesh R <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
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
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, Robert Nelson <robertcnelson@gmail.com>
Subject: Re: [PATCH v4 3/6] mfd: ti_am335x_tscadc: Remove unwanted
 reg_se_cache save
Message-ID: <20141120144028.GB5809@localhost.localdomain>
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com>
 <1415941651-28962-4-git-send-email-vigneshr@ti.com>
 <20141118143005.GF24004@x1>
 <20141118171240.GB3003@dtor-ws>
 <546DF2F0.9080405@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546DF2F0.9080405@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 07:26:00PM +0530, Sekhar Nori wrote:
> I tested this using lcd7 cape connected to beaglebone black. The latest
> kernel I could find on this board was a TI BSP based v3.14 kernel. So I
> had to port these patches to that kernel. Cc Robert Nelson to see if he
> knows about a more recent kernel supporting that cape.

What is missing from mainline for the black?

(I thought it was fully supported by now.)
 
> I did not see any breakage with these patches applied although I did not
> see any noticeable performance improvement as well.

So, the jumping on pen-up persists, right?  That means the patch
series does not provide a general fix for that issue.
 
> I also tested this series on AM335x EVM using the v3.18-rc5 kernel.
> Again, no breakage but no improvement as well.

You still have jumps on a pen up event?

Thanks,
Richard
