Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3J3J4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 05:56:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43411 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752965Ab3J3J4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 05:56:40 -0400
Date: Wed, 30 Oct 2013 06:56:41 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: dwmw2@infradead.org, yongjun_wei@trendmicro.com.cn,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mtd: remove duplicated include from mtdcore.c
Message-ID: <20131030095640.GC2453@localhost>
References: <CAPgLHd8=fLjqnKEoTB2C+7R=Nz7bdV0D5ttO29em=P8nX-Tvag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPgLHd8=fLjqnKEoTB2C+7R=Nz7bdV0D5ttO29em=P8nX-Tvag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 01:34:22PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mtd/mtdcore.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index 7189089..92311a5 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -37,7 +37,6 @@
>  #include <linux/backing-dev.h>
>  #include <linux/gfp.h>
>  #include <linux/slab.h>
> -#include <linux/major.h>
>  
>  #include <linux/mtd/mtd.h>
>  #include <linux/mtd/partitions.h>
> 
> 

Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Ooops.. sorry about that. This was introduced by me in this one:

commit 40d1b2e461f28c4add582ef7ca8ed9f16f6b5add
Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Date:   Sun Oct 13 18:05:23 2013 -0300

mtd: Move major number definitions to major.h
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
