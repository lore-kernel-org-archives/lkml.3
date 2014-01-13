Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaAMX4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:56:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaAMX4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:56:14 -0500
Date: Mon, 13 Jan 2014 15:56:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Pol Eyschen <poleyschen@gmail.com>
Cc: sachin.kamat@linaro.org, jack@suse.cz, ufimtseva@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Pol Eyschen <poleyschen@hotmail.com>
Subject: Re: [PATCH] Staging: ced1401: fix coding style in ced_ioc.c
Message-ID: <20140113235650.GA23380@kroah.com>
References: <1389642100-3601-1-git-send-email-poleyschen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389642100-3601-1-git-send-email-poleyschen@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 08:41:40PM +0100, Pol Eyschen wrote:
> From: Pol Eyschen <poleyschen@hotmail.com>
> 
> All comments fixed to match the kernel coding style.
> 
> Signed-off-by: Pol Eyschen <poleyschen@gmail.com>
> ---
>  drivers/staging/ced1401/ced_ioc.c |  382 ++++++++++++++++++++++++-------------
>  1 file changed, 249 insertions(+), 133 deletions(-)
> 
> diff --git a/drivers/staging/ced1401/ced_ioc.c b/drivers/staging/ced1401/ced_ioc.c
> index 62efd74..e5172cb 100644
> --- a/drivers/staging/ced1401/ced_ioc.c
> +++ b/drivers/staging/ced1401/ced_ioc.c
> @@ -41,7 +41,8 @@ static void FlushOutBuff(DEVICE_EXTENSION *pdx)
>  {
>  	dev_dbg(&pdx->interface->dev, "%s currentState=%d", __func__,
>  		pdx->sCurrentState);
> -	if (pdx->sCurrentState == U14ERR_TIME)	/* Do nothing if hardware in trouble */
> +	if (pdx->sCurrentState == U14ERR_TIME)
> +		/* Do nothing if hardware in trouble */
>  		return;

Please wrap stuff like this in { } to not confuse people.

thanks,

greg k-h
