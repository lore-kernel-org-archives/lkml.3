Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3LUN5V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 08:57:21 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:37635 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab3LUN5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 08:57:19 -0500
Subject: Re: [PATCH -next] misc: genwqe: remove unused including
 <linux/version.h>
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: gregkh@linuxfoundation.org, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAPgLHd-SWJT8hXN0TPO5E-c2pGnJOOfUP-8NEOMAZBC-nJAQKw@mail.gmail.com>
References: <CAPgLHd-SWJT8hXN0TPO5E-c2pGnJOOfUP-8NEOMAZBC-nJAQKw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Sat, 21 Dec 2013 14:57:06 +0100
Message-ID: <1387634226.7575.3.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122113-0542-0000-0000-0000077A255E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wei,

Am Samstag, den 21.12.2013, 17:23 +0800 schrieb Wei Yongjun:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove including <linux/version.h> that don't need it.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/misc/genwqe/card_sysfs.c | 1 -
>  drivers/misc/genwqe/card_base.h  | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/drivers/misc/genwqe/card_sysfs.c b/drivers/misc/genwqe/card_sysfs.c
> index a72a992..acd97f3 100644
> --- a/drivers/misc/genwqe/card_sysfs.c
> +++ b/drivers/misc/genwqe/card_sysfs.c
> @@ -24,7 +24,6 @@
>   * debugging, please also see the debugfs interfaces of this driver.
>   */
> 
> -#include <linux/version.h>
>  #include <linux/kernel.h>
>  #include <linux/types.h>
>  #include <linux/module.h>
> 
> diff --git a/drivers/misc/genwqe/card_base.h b/drivers/misc/genwqe/card_base.h
> index 41953e3..f034bd7 100644
> --- a/drivers/misc/genwqe/card_base.h
> +++ b/drivers/misc/genwqe/card_base.h
> @@ -34,7 +34,6 @@
>  #include <linux/semaphore.h>
>  #include <linux/uaccess.h>
>  #include <linux/io.h>
> -#include <linux/version.h>
>  #include <linux/debugfs.h>
> 
>  #include <linux/genwqe/genwqe_card.h>
> 
Thanks for removing the obsolete includes.

Acked-by: Frank Haverkamp <haver@linux.vnet.ibm.com>

