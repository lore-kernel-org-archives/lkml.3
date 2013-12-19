Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab3LSJAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:00:49 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61010 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab3LSJAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:00:47 -0500
Date: Thu, 19 Dec 2013 09:00:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] mfd: ti_am335x: drop am335x_tsc_se_update() from
 resume path
Message-ID: <20131219090040.GH2621@lee--X1>
References: <1387385577-24447-1-git-send-email-bigeasy@linutronix.de>
 <1387385577-24447-5-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387385577-24447-5-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The update of the SE register in MFD doesn't look right as it has
> nothing to do with it. The better place to do it is in TSC driver (which
> is already doint it) and in the ADC driver which needs this only in the
> continues mode.

When you resubmit the patch-set complete with Acks, please ensure you
spell check and proof read _all_ of your commit logs.

> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/iio/adc/ti_am335x_adc.c | 2 ++
>  drivers/mfd/ti_am335x_tscadc.c  | 1 -
>  2 files changed, 2 insertions(+), 1 deletion(-)

For the MFD part:
  Acked-by: Lee Jones <lee.jones@linaro.org>

It's probably best that we suck these changes up through the MFD tree,
so once the review comments have been satisfied and we have all
relevant Acks I can take them in and create an immutable branch for
you guys to pull from if you like.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
