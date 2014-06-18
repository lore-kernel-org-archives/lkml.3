Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965324AbaFRIcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:32:14 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:49469 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182AbaFRIcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:32:12 -0400
Date: Wed, 18 Jun 2014 09:32:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/10] mfd: Add driver for Maxim 77802 Power
 Management IC
Message-ID: <20140618083204.GP21030@lee--X1>
References: <1402941758-11216-1-git-send-email-javier.martinez@collabora.co.uk>
 <1402941758-11216-7-git-send-email-javier.martinez@collabora.co.uk>
 <20140616192720.GK5099@sirena.org.uk>
 <53A01F09.5070106@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53A01F09.5070106@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +config MFD_MAX77802
> >> +	tristate "Maxim Integrated MAX77802 PMIC Support"
> >> +	depends on I2C=y
> >> +	select MFD_CORE
> >> +	select REGMAP_I2C
> >> +	select REGMAP_IRQ
> >> +	select IRQ_DOMAIN
> >> +	help
> >> +	  Say yes here to support for Maxim Integrated MAX77802.
> >> +	  This is a Power Management IC with RTC on chip.
> >> +	  This driver provides common support for accessing the device;
> >> +	  additional drivers must be enabled in order to use the functionality
> >> +	  of the device.
> >> +
> > 
> > It is a bit unorthodox to put the build infrastructure in the same patch
> > as the DT binding...
> > 
> 
> I thought it was the opposite. That a DT binding document has to be added along
> with the first user of the binding but I'll separate the DT doc in another patch
> then if that is the right thing to do.

This was the 'old' method, but changed a little over a year ago.

> Thanks a lot for all your suggestions, I'll wait a little to see if there is
> more feedback and repost a v3 addressing all the issues you pointed out.

Just re-post it.  I'll review the next version.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
