Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaCKHU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 03:20:26 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:58639 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaCKHUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 03:20:24 -0400
Date: Tue, 11 Mar 2014 07:20:19 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML-INPUT <linux-input@vger.kernel.org>,
        LKML-KERNEL <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH V2] input: misc: da9063: OnKey driver
Message-ID: <20140311072019.GI2839@lee--X1>
References: <201403101740.s2AHebta017785@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201403101740.s2AHebta017785@swsrvapps-01.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> 
> Add the OnKey driver for DA9063
> 
> Plus some minor dependencies:
> - Addition of "ONKEY" name to OnKey IRQ resource structure;
> - Bool key_power platform data driver configuration option.
> 
> Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> ---
> 
>  drivers/input/misc/Kconfig        |   10 ++
>  drivers/input/misc/Makefile       |    1 +
>  drivers/input/misc/da9063-onkey.c |  209 +++++++++++++++++++++++++++++++++++++
>  drivers/mfd/da9063-core.c         |    1 +
>  include/linux/mfd/da9063/pdata.h  |    1 +

For the MFD parts:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
