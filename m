Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbbASJza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:55:30 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:58040 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbbASJzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:55:25 -0500
Date: Mon, 19 Jan 2015 09:55:20 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] mfd: db8500-prcmu:  Remove unused function
Message-ID: <20150119095520.GN21886@x1>
References: <1420134593-690-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420134593-690-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Jan 2015, Rickard Strandqvist wrote:

> Remove the function prcmu_get_boot_status() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/mfd/db8500-prcmu.c |    9 ---------
>  1 file changed, 9 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
> index 193cf16..b517501 100644
> --- a/drivers/mfd/db8500-prcmu.c
> +++ b/drivers/mfd/db8500-prcmu.c
> @@ -675,15 +675,6 @@ bool prcmu_has_arm_maxopp(void)
>  }
>  
>  /**
> - * prcmu_get_boot_status - PRCMU boot status checking
> - * Returns: the current PRCMU boot status
> - */
> -int prcmu_get_boot_status(void)
> -{
> -	return readb(tcdm_base + PRCM_BOOT_STATUS);
> -}
> -
> -/**
>   * prcmu_set_rc_a2p - This function is used to run few power state sequences
>   * @val: Value to be set, i.e. transition requested
>   * Returns: 0 on success, -EINVAL on invalid argument

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
