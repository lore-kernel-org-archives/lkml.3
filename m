Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaKRRMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:12:51 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:44760 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbaKRRMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:12:46 -0500
Date: Tue, 18 Nov 2014 09:12:40 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Vignesh R <vigneshr@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        richardcochran@gmail.com,
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
Subject: Re: [PATCH v4 3/6] mfd: ti_am335x_tscadc: Remove unwanted
 reg_se_cache save
Message-ID: <20141118171240.GB3003@dtor-ws>
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com>
 <1415941651-28962-4-git-send-email-vigneshr@ti.com>
 <20141118143005.GF24004@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118143005.GF24004@x1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 02:30:05PM +0000, Lee Jones wrote:
> On Fri, 14 Nov 2014, Vignesh R wrote:
> 
> > In one shot mode, sequencer automatically disables all enabled steps at
> > the end of each cycle. (both ADC steps and TSC steps) Hence these steps
> > need not be saved in reg_se_cache for clearing these steps at a later
> > stage.
> > Also, when ADC wakes up Sequencer should not be busy executing any of the
> > config steps except for the charge step. Previously charge step was 1 ADC
> > clock cycle and hence it was ignored.
> > 
> > Signed-off-by: Vignesh R <vigneshr@ti.com>
> > ---
> >  drivers/mfd/ti_am335x_tscadc.c       | 7 +++++--
> >  include/linux/mfd/ti_am335x_tscadc.h | 1 +
> >  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> Code looks better now.
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> What's the plan for this series?

I am waiting for the interested parties to provide more feedback. So far
I have seen a few reports saying that they see issues with the series
applied.

-- 
Dmitry
