Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaGHKRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:17:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50579 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaGHKRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:17:07 -0400
Date: Tue, 8 Jul 2014 13:16:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: James A Shackleford <shack@linux.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] staging: rtl8712: remove inapplicable comment
Message-ID: <20140708101653.GJ25880@mwanda>
References: <1403664761-15728-1-git-send-email-shack@linux.com>
 <1403664761-15728-2-git-send-email-shack@linux.com>
 <1403664761-15728-3-git-send-email-shack@linux.com>
 <1403664761-15728-4-git-send-email-shack@linux.com>
 <1403664761-15728-5-git-send-email-shack@linux.com>
 <1403664761-15728-6-git-send-email-shack@linux.com>
 <1403664761-15728-7-git-send-email-shack@linux.com>
 <1403664761-15728-8-git-send-email-shack@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403664761-15728-8-git-send-email-shack@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 10:52:41PM -0400, James A Shackleford wrote:
> Signed-off-by: James A Shackleford <shack@linux.com>
> ---
>  drivers/staging/rtl8712/osdep_service.h |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
> index 77b1443..3dfc473 100644
> --- a/drivers/staging/rtl8712/osdep_service.h
> +++ b/drivers/staging/rtl8712/osdep_service.h
> @@ -95,11 +95,6 @@ static inline void _set_workitem(_workitem *pwork)
>  	#define BIT(x)	(1 << (x))
>  #endif
>  
> -/*
> -For the following list_xxx operations,
> -caller must guarantee the atomic context.
> -Otherwise, there will be racing condition.
> -*/
>  static inline u32 _down_sema(struct semaphore *sema)
>  {
>  	if (down_interruptible(sema))

This function sucks obviously just like the wrappers you deleted earlier.

Only one of the callers checks the return value.

TODO-list: 2014-07-08: rtl8712: delete _down_sema().

regards,
dan carpenter

