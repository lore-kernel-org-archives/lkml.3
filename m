Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbaEIKmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:42:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24487 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbaEIKmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:42:17 -0400
Date: Fri, 9 May 2014 13:42:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, himangi774@gmail.com, sachin.kamat@linaro.org,
        fempsci@gmail.com, nandu.hgowda@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: cxt1e1: Fix no spaces at the start of a
 line in musycc.c
Message-ID: <20140509104202.GG4963@mwanda>
References: <20140509100220.GA6446@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509100220.GA6446@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 07:02:20PM +0900, Daeseok Youn wrote:
> clean up checkpatch.pl warning:
>  WARNING: please no spaces at the start of a line in
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---

> -#ifdef RLD_TRANS_DEBUGx
> -    if (1 || cxt1e1_log_level >= LOG_MONITOR2)
> +#ifdef RLD_TRANS_DEBUG
> +	if (1 || cxt1e1_log_level >= LOG_MONITOR2)
>  #else

You fixed a typo here.  I don't care about it, because we are going to
delete this code anyway.  But normally I would ask you to redo the patch
because it should be done separately, and it should be described in the
changelog instead of slipped in secretly.

But in this case, I don't care so you got lucky.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

