Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab3KRKnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 05:43:55 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:46571 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3KRKnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 05:43:47 -0500
Date: Mon, 18 Nov 2013 10:43:43 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Derek Basehore <dbasehore@chromium.org>
Subject: Re: [PATCH 2/3] mfd: cros ec: spi: Increase EC transaction delay
Message-ID: <20131118104343.GG13640@lee--X1>
References: <1384770649-8593-1-git-send-email-treding@nvidia.com>
 <1384770649-8593-2-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384770649-8593-2-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Thierry Reding wrote:

> From: Derek Basehore <dbasehore@chromium.org>
> 
> 50 us is not a long enough delay between EC transactions. At least 70 us
> are needed for the 16 MHz STM32L part. Increase the delay to 200 us for
> an extra safety margin.
> 
> Signed-off-by: Derek Basehore <dbasehore@chromium.org>
> Reviewed-by: Randall Spangler <rspangler@chromium.org>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/mfd/cros_ec_spi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

As I'm sure you've tested this and you didn't notice any new undue
latency, I'll apply the patch, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
