Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaHDIJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 04:09:15 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:45454 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaHDIJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:09:13 -0400
Date: Mon, 4 Aug 2014 09:09:08 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Hans Wennborg <hans@hanshq.net>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/19] mfd: omap-usb-host: fix %d confusingly prefixed
 with 0x in format string
Message-ID: <20140804080908.GB3935@lee--X1>
References: <1407111567-14778-1-git-send-email-hans@hanshq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407111567-14778-1-git-send-email-hans@hanshq.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Aug 2014, Hans Wennborg wrote:

> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  drivers/mfd/omap-usb-host.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 33a9234..83dab2f 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -647,7 +647,7 @@ static int usbhs_omap_probe(struct platform_device *pdev)
>  		default:
>  			omap->nports = OMAP3_HS_USB_PORTS;
>  			dev_dbg(dev,
> -			 "USB HOST Rev:0x%d not recognized, assuming %d ports\n",
> +			 "USB HOST Rev:0x%x not recognized, assuming %d ports\n",
>  			 omap->usbhs_rev, omap->nports);
>  			break;
>  		}

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
