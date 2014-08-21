Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaHUINa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:13:30 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:49145 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbaHUIN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:13:26 -0400
Date: Thu, 21 Aug 2014 09:13:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Hans Wennborg <hans@hanshq.net>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/15] mfd: rtsx_usb: fix decimal printf format
 specifiers prefixed with 0x
Message-ID: <20140821081321.GQ4266@lee--X1>
References: <1407300148-32557-1-git-send-email-hans@hanshq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407300148-32557-1-git-send-email-hans@hanshq.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Aug 2014, Hans Wennborg wrote:

> The prefix suggests the number should be printed in hex, so use
> the %x specifier to do that.
> 
> Found by using regex suggested by Joe Perches.
> 
> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  drivers/mfd/rtsx_usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
> index 6352bec..2d488e9 100644
> --- a/drivers/mfd/rtsx_usb.c
> +++ b/drivers/mfd/rtsx_usb.c
> @@ -684,7 +684,7 @@ static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
>  	struct rtsx_ucr *ucr =
>  		(struct rtsx_ucr *)usb_get_intfdata(intf);
>  
> -	dev_dbg(&intf->dev, "%s called with pm message 0x%04u\n",
> +	dev_dbg(&intf->dev, "%s called with pm message 0x%04x\n",
>  			__func__, message.event);
>  
>  	/*

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
