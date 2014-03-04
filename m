Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbaCDIqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 03:46:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51602 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaCDIqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:46:20 -0500
Date: Tue, 4 Mar 2014 11:45:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, shaun@xresource.ca,
        sachin.kamat@linaro.org, linux-kernel@vger.kernel.org,
        dulshani.gunawardhana89@gmail.com, ying.xue@windriver.com,
        davem@davemloft.net
Subject: Re: [PATCH 3/7] staging: cxt1e1: Fix line length over 80 characters
 in linux.c
Message-ID: <20140304084555.GS26722@mwanda>
References: <2825545.2YpN0JuVSn@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2825545.2YpN0JuVSn@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 11:08:46AM +0900, Daeseok Youn wrote:
> 
> clean up checkpatch.pl warnings:
>  WARNING: Line length over 80 characters
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/staging/cxt1e1/linux.c |   48 +++++++++++++++++++++++++--------------
>  1 files changed, 31 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
> index 17d73f4..579e68e 100644
> --- a/drivers/staging/cxt1e1/linux.c
> +++ b/drivers/staging/cxt1e1/linux.c
> @@ -31,7 +31,7 @@
>  #include "pmcc4_private.h"
>  #include "sbeproc.h"
>  
> -/*****************************************************************************************
> +/*******************************************************************************

This should just be:

/*
 *
 *

Not ************************************************** etc.

Fix in a later patch if you want.

regards,
dan carpenter


