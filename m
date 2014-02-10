Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaBJLvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:51:21 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:46345 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbaBJLvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:51:17 -0500
Date: Mon, 10 Feb 2014 11:51:09 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/8] ASoC: da9055: Fix device registration of PMIC and
 CODEC devices
Message-ID: <20140210115109.GC22773@lee--X1>
References: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
 <6a398d176b0b2bf8792d27bd5e2995fd96afb32d.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
 <20140207105657.GL14727@lee--X1>
 <20140207125831.GL32298@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140207125831.GL32298@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +/*
> > > + * DO NOT change the device Ids. The naming is intentionally specific as both
> > > + * the PMIC and CODEC parts of this chip are instantiated separately as I2C
> > > + * devices (both have configurable I2C addresses, and are to all intents and
> > > + * purposes separate). As a result there are specific DA9055 ids for PMIC
> > > + * and CODEC, which must be different to operate together.
> > > + */
> 
> > I'm not sure this comment is required.
> 
> They are, we've already had the suffixes removed from both PMIC and
> CODEC drivers by people doing code review causing the drivers to fail to
> load for several kernel releases (this should be tagged to stable as a
> result).
> 
> > Most device IDs are named this way.
> 
> Having the suffix on a subdevice would be normal but it's not normal for
> the primary I2C device, usually you can just put the part number in.

Okay, no problem then. Ignore my last.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
