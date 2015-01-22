Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbbAVH61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:58:27 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:46730 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbbAVH6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:58:18 -0500
Date: Thu, 22 Jan 2015 07:58:11 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
Cc: Sebastian Reichel <sre@kernel.org>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Hartmut Knaack <knaack.h@gmx.de>,
        linux-iio@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        support.opensource@diasemi.com
Subject: Re: [PATCH v6 0/7] Add initial support for DA9150 Charger &
 Fuel-Gauge IC
Message-ID: <20150122075811.GO22024@x1>
References: <cover.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
 <20150121165250.GG13715@earth.universe>
 <C1079F30-5D1D-45AA-A129-FE1E68EA5DC5@jic23.retrosnub.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C1079F30-5D1D-45AA-A129-FE1E68EA5DC5@jic23.retrosnub.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Jonathan Cameron wrote:

> 
> 
> On 21 January 2015 16:52:50 GMT+00:00, Sebastian Reichel <sre@kernel.org> wrote:
> >Hi,
> >
> >On Wed, Jan 21, 2015 at 03:46:25PM +0000, Adam Thomson wrote:
> >> This patch set adds initial support for the Dialog DA9150 Integrated
> >Charger &
> >> Fuel-Gauge IC. The device also provides GPIO and GPADC functionality.
> >> 
> >> In this patch set the following is provided:
> >>  - MFD Core support and DT bindings documentation.
> >>  - IIO GPADC support and DT bindings documentation.
> >>  - Power Supply Charger support and DT bindings documentation.
> >>  - Update to MAINTAINERS file to add DA9150 files to Dialog support
> >list.
> >> 
> >> To keep patch submission from being too large, support for GPIO and
> >Fuel-Gauge
> >> will come after initial support patches are accepted.
> >> 
> >> This patch set is baselined against the v3.19-rc5 kernel version.
> >> 
> >> Changes in v6:
> >> - For GPADC driver, Use lower case extended names for IIO GPADC
> >channels, and
> >>   remove extended names for GPIO related channels.
> >> - For charger driver, revert to no devm IRQ request/free functions as
> >ordering
> >>   is important, and probe failure scenario was not being correctly
> >covered. A
> >>   helper function for free IRQs has been added to make code cleaner.
> >
> >Probably a devm_ variant of power_supply_register should be created,
> >but for now this is ok for me.
> >
> >Jonathan, Lee: I assume you are ok with the whole patchset going
> >through the power supply subsystem?
> >
> Fine by me if either power supply or MFD.

I am, but there is a lot of MFD code here, so I'd like to take it in
as well.  I'd like a tagged pull-request from Sebastian.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
