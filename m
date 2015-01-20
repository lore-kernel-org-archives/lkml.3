Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbbATNnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:43:15 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:54446 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbbATNnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:43:13 -0500
Date: Tue, 20 Jan 2015 13:43:04 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] mfd: omap-usb-host: Remove some unused functions
Message-ID: <20150120134304.GJ13701@x1>
References: <1420330281-5228-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420330281-5228-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Jan 2015, Rickard Strandqvist wrote:

> Removes some functions that are not used anywhere:
> usbhs_readb() usbhs_writeb()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/mfd/omap-usb-host.c |   10 ----------
>  1 file changed, 10 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 83dab2f..6b0f305 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -129,16 +129,6 @@ static inline u32 usbhs_read(void __iomem *base, u32 reg)
>  	return readl_relaxed(base + reg);
>  }
>  
> -static inline void usbhs_writeb(void __iomem *base, u8 reg, u8 val)
> -{
> -	writeb_relaxed(val, base + reg);
> -}
> -
> -static inline u8 usbhs_readb(void __iomem *base, u8 reg)
> -{
> -	return readb_relaxed(base + reg);
> -}
> -
>  /*-------------------------------------------------------------------------*/
>  
>  /**

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
