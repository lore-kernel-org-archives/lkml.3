Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaBGSAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:00:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaBGSAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:00:48 -0500
Date: Fri, 7 Feb 2014 10:01:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Pol Eyschen <poleyschen@gmail.com>
Cc: sachin.kamat@linaro.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ufimtseva@gmail.com
Subject: Re: [PATCH] staging: ced1401: fix coding style in ced_ioc.c (resend)
Message-ID: <20140207180157.GA7677@kroah.com>
References: <1389821834-17601-1-git-send-email-poleyschen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389821834-17601-1-git-send-email-poleyschen@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 10:37:13PM +0100, Pol Eyschen wrote:
> Fixed checkpatch.pl issues and removed redundant comment in ced_ioc.cs
> 
> Signed-off-by: Pol Eyschen <poleyschen@gmail.com>
> ---
>  drivers/staging/ced1401/ced_ioc.c |  483 +++++++++++++++++++++----------------
>  1 file changed, 271 insertions(+), 212 deletions(-)
> 
> diff --git a/drivers/staging/ced1401/ced_ioc.c b/drivers/staging/ced1401/ced_ioc.c
> index bf532b1..94a361d 100644
> --- a/drivers/staging/ced1401/ced_ioc.c
> +++ b/drivers/staging/ced1401/ced_ioc.c
> @@ -40,8 +40,8 @@ static void FlushOutBuff(DEVICE_EXTENSION *pdx)
>  {
>  	dev_dbg(&pdx->interface->dev, "%s currentState=%d", __func__,
>  		pdx->sCurrentState);
> -	if (pdx->sCurrentState == U14ERR_TIME)	/* Do nothing if hardware in trouble */
> -		return;
> +	if (pdx->sCurrentState == U14ERR_TIME)
> +		return;	/* Do nothing if hardware in trouble */

That's really not a good cleanup, is it?

And this patch no longer applies to my tree, care to fix it up and
resend?

thanks,

greg k-h
