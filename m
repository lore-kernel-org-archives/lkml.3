Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab3HZQjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:39:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20895 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3HZQjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:39:51 -0400
Date: Mon, 26 Aug 2013 19:39:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        harsh1kumar@gmail.com, linux-kernel@vger.kernel.org,
        mujeeb.adil@gmail.com, justinmattock@gmail.com
Subject: Re: [PATCH 23/24] Staging: winbond: wbusb: fixed some lines over 80
 characters
Message-ID: <20130826163933.GF6329@mwanda>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
 <1377529823-5116-24-git-send-email-ikerpedrosam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377529823-5116-24-git-send-email-ikerpedrosam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 05:10:22PM +0200, Iker Pedrosa wrote:
> Fixed some lines over 80 characters.
> 
> Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
> ---
>  drivers/staging/winbond/wbusb.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
> index 3fa1ae4..c128bc9 100644
> --- a/drivers/staging/winbond/wbusb.c
> +++ b/drivers/staging/winbond/wbusb.c
> @@ -169,7 +169,8 @@ static void hal_set_radio_mode(struct hw_data *pHwData, unsigned char radio_off)
>  	Wb35Reg_Write(pHwData, 0x0824, reg->M24_MacControl);
>  }
>  
> -static void hal_set_current_channel_ex(struct hw_data *pHwData, struct chan_info channel)
> +static void hal_set_current_channel_ex(struct hw_data *pHwData,
> +					       struct chan_info channel)


These should be aligned like this:

static void hal_set_current_channel_ex(struct hw_data *pHwData,
				       struct chan_info channel)
{


regards,
dan carpenter
