Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935243AbaH0RFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:05:14 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58027 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaH0RFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:05:12 -0400
Date: Wed, 27 Aug 2014 18:05:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jenny Tc <jenny.tc@intel.com>
Subject: Re: [RESEND PATCH v3 3/6] charger: max14577: Configure
 battery-dependent settings from DTS and sysfs
Message-ID: <20140827170503.GD24579@lee--X1>
References: <1409146282-25075-1-git-send-email-k.kozlowski@samsung.com>
 <1409146282-25075-4-git-send-email-k.kozlowski@samsung.com>
 <20140827135027.GF6364@lee--X1>
 <1409147725.25748.1.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409147725.25748.1.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:

> On śro, 2014-08-27 at 14:50 +0100, Lee Jones wrote:
> > On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:
> > 
> > > Remove hard-coded values for:
> > >  - Fast Charge current,
> > >  - End Of Charge current,
> > >  - Fast Charge timer,
> > >  - Overvoltage Protection Threshold,
> > >  - Battery Constant Voltage,
> > > and use DTS or sysfs to configure them. This allows using the max14577 charger
> > > driver with different batteries.
> > > 
> > > Now the charger driver requires valid configuration data from DTS. In
> > > case of wrong configuration data it fails during probe. Patch adds
> > > of_compatible to the charger mfd cell in MFD driver core.
> > > 
> > > The fast charge timer is configured through sysfs entry.
> > > 
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > > Cc: David Woodhouse <dwmw2@infradead.org>
> > > Cc: Jenny Tc <jenny.tc@intel.com>
> > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > Acked-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/mfd/max14577.c               |   5 +-
> > 
> > Hmm... not sure why I Acked this.  The code looks okay, but can you
> > break out the MFD changed into a separate patch please?  You can add
> > my Ack to the broken out patch though.
> 
> Sure, I'll split it however the compatible here in mfd_cell makes sense
> only with this patch.

That's completely fine.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
