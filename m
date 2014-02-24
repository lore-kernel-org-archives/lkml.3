Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaBXQF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:05:57 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:63043 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbaBXQFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:05:55 -0500
Date: Mon, 24 Feb 2014 16:05:47 +0000
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
Subject: Re: [RFCv1 4/4] mfd: twl4030-madc: Move driver to drivers/iio/adc
Message-ID: <20140224160547.GD15847@lee--X1>
References: <20140214174040.GB26969@earth.universe>
 <1392403586-30540-1-git-send-email-sre@debian.org>
 <1392403586-30540-4-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392403586-30540-4-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a driver for an A/D converter, which belongs into
> drivers/iio/adc.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  drivers/iio/adc/Kconfig        |  10 +
>  drivers/iio/adc/Makefile       |   1 +
>  drivers/iio/adc/twl4030-madc.c | 922 +++++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/Kconfig            |  10 -
>  drivers/mfd/Makefile           |   1 -
>  drivers/mfd/twl4030-madc.c     | 922 -----------------------------------------
>  6 files changed, 933 insertions(+), 933 deletions(-)
>  create mode 100644 drivers/iio/adc/twl4030-madc.c
>  delete mode 100644 drivers/mfd/twl4030-madc.c

For the MFD changes:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
