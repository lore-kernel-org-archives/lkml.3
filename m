Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaCJKoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:44:06 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:52003 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbaCJKoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:44:03 -0400
Date: Mon, 10 Mar 2014 10:43:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCHv2 0/9] Convert twl4030-madc to IIO API and add DT support
Message-ID: <20140310104356.GL14976@lee--X1>
References: <1393702365-26429-1-git-send-email-sre@debian.org>
 <1393970751-18157-1-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393970751-18157-1-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> TODO:
>  * Wait for feedback from DT binding maintainers
>  * Wait for feedback from Marek Belisko, who is testing the
>    changes with twl4030-madc-battery driver on GTA04

This patch-set has stalled.

Can you send a fresh patch-set (not linked to the old ones, as the
thread is getting very complicated again) complete with all the Acks
you have received?

> [0] https://lkml.org/lkml/2014/3/1/105
> 
> -- Sebastian
> 
> Sebastian Reichel (9):
>   mfd: twl4030-madc: Use managed resources
>   mfd: twl4030-madc: Add DT support and convert to IIO framework
>   mfd: twl4030-madc: Cleanup driver
>   mfd: twl-core: Add twl_i2c_read/write_u16
>   mfd: twl4030-madc: Use twl_i2c_read/write_u16 for 16 bit registers
>   Documentation: DT: Document twl4030-madc binding
>   mfd: twl4030-madc: Move driver to drivers/iio/adc
>   iio: documentation: Add ABI documentation for *_mean_raw
>   iio: inkern: add iio_read_channel_average_raw
> 
>  Documentation/ABI/testing/sysfs-bus-iio            |   8 +
>  .../devicetree/bindings/iio/adc/twl4030-madc.txt   |  24 ++
>  drivers/iio/adc/Kconfig                            |  10 +
>  drivers/iio/adc/Makefile                           |   1 +
>  drivers/{mfd => iio/adc}/twl4030-madc.c            | 299 +++++++++++++--------
>  drivers/iio/inkern.c                               |  18 ++
>  drivers/mfd/Kconfig                                |  10 -
>  drivers/mfd/Makefile                               |   1 -
>  include/linux/i2c/twl.h                            |  12 +
>  include/linux/i2c/twl4030-madc.h                   |   2 +-
>  include/linux/iio/consumer.h                       |  13 +
>  11 files changed, 274 insertions(+), 124 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
>  rename drivers/{mfd => iio/adc}/twl4030-madc.c (75%)
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
