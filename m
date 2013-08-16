Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3HPARo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 20:17:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3HPARn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 20:17:43 -0400
Date: Thu, 15 Aug 2013 17:19:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "paulmcquad@gmail.com" <paulmcquad@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] Staging:BCM:DDRInit.c:Replacing __FUNCTION__
Message-ID: <20130816001918.GA7450@kroah.com>
References: <alpine.DEB.2.02.1308152213010.7299@paul87-DT2110>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308152213010.7299@paul87-DT2110>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 10:21:29PM +0100, paulmcquad@gmail.com wrote:
> 
> __Function__ gets replaced with __func__
> 
> Signed-Off-By: Paul McQuade <paulmcquad@gmail.com>
> ---
>  drivers/staging/bcm/DDRInit.c |   54 
> ++++++++++++++++++++---------------------
>  1 file changed, 27 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
> index 8c696b6..f5eda96 100644
> --- a/drivers/staging/bcm/DDRInit.c
> +++ b/drivers/staging/bcm/DDRInit.c
> @@ -828,13 +828,13 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
>  		{
>  				retval= rdmalt(Adapter,(UINT)0x0f000830, 
> &uiResetValue, sizeof(uiResetValue));
>  				if(retval < 0) {
> -					BCM_DEBUG_PRINT(Adapter,CMHOST, 
> RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
> +					BCM_DEBUG_PRINT(Adapter, CMHOST, 
> RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);

This patch is line-wrapped, and can't be applied :(

Can you take a look at the file, Documentation/email_clients.txt and fix
up your email client so that you can send patches properly?

thanks,

greg k-h
