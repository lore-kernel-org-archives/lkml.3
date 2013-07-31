Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094Ab3GaJkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:40:12 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41049 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3GaJkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:40:10 -0400
Date: Wed, 31 Jul 2013 10:40:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] mfd: wm831x: Remove erronious bits per word set
Message-ID: <20130731094004.GA13298@lee--X1>
References: <1375186795-28823-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375186795-28823-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Mark Brown <broonie@linaro.org>
> 
> Since the conversion to the regmap API setting bits per word will lead to
> data corruption since the regmap API already configures the bits per word
> appropriately.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/wm831x-spi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/mfd/wm831x-spi.c b/drivers/mfd/wm831x-spi.c

Applied, thanks Mark.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
