Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaBSIOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:14:00 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:59608 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaBSIN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:13:57 -0500
Date: Wed, 19 Feb 2014 08:13:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Milo Kim <milo.kim@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 01/10] mfd: Add TI LMU driver
Message-ID: <20140219081350.GA10504@lee--X1>
References: <1392359450-6890-1-git-send-email-milo.kim@ti.com>
 <20140217095734.GD17875@lee--X1>
 <53030F9C.8000605@ti.com>
 <20140218082127.GD20218@lee--X1>
 <5303F3B5.6050806@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5303F3B5.6050806@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>>+	pdata->en_gpio = of_get_named_gpio(node, "ti,enable-gpio", 0);
> >>>
> >>>There is a global DT property for this already.
> >>
> >>I've not found it yet, but I agree it looks like general property.
> >>So I'll replace "ti,enable-gpio" with "ti,lmu-en-gpio".
> >
> >Just re-use "gpio-enable". No need for it to be vendor specific.
> >
> 
> Got it. Thanks!
> 
> This GPIO is used for enabling the device. So, "enable-gpio" is more
> appropriate name, isn't it?

Yes, I wrote it the wrong way round (typo).

Just grep for both, you will see which one to use.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
