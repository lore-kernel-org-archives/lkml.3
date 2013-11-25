Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3KYJgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:36:51 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46121 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3KYJgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:36:46 -0500
Date: Mon, 25 Nov 2013 09:36:39 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Uwe =?iso-8859-1?Q?Kleine-K=F6nig'?=" 
	<u.kleine-koenig@pengutronix.de>,
        "'Marc Reilly'" <marc@cpdesign.com.au>
Subject: Re: [PATCH] mfd: mc13xxx: remove unnecessary spi_set_drvdata()
Message-ID: <20131125093639.GC17722@lee--X1>
References: <002601cee98e$44f75210$cee5f630$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <002601cee98e$44f75210$cee5f630$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Nov 2013, Jingoo Han wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/mc13xxx-spi.c |    1 -
>  1 file changed, 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
