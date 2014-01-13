Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaAMVmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 16:42:46 -0500
Received: from einonm.plus.com ([80.229.23.162]:36045 "EHLO mail.einon.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbaAMVmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 16:42:43 -0500
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2014 16:42:43 EST
Date: Mon, 13 Jan 2014 21:35:53 +0000
From: Mark Einon <mark@einon.net>
To: Pol Eyschen <poleyschen@gmail.com>
Cc: gregkh@linuxfoundation.org, sachin.kamat@linaro.org, jack@suse.cz,
        ufimtseva@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Pol Eyschen <poleyschen@hotmail.com>
Subject: Re: [PATCH] Staging: ced1401: fix coding style in ced_ioc.c
Message-ID: <20140113213552.GA5368@einon.net>
References: <1389642100-3601-1-git-send-email-poleyschen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389642100-3601-1-git-send-email-poleyschen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

This patch doesn't apply to my staging-next branch. Are you making your
changes to the staging-next branch of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git?

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

Putting a comment after a single line 'if' and before the statement is
not the norm and can be confusing. Please don't do it.

Also, quite a few of the comments you're moving around here look to be
unecessary, and can probably be deleted.

Mark
