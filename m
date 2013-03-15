Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab3COVWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 17:22:03 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:58401 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab3COVWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 17:22:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-xJ4+5e5UMMeF4G6RtWAb=xxDZ_JKE9tNZn057Eym8jw@mail.gmail.com>
References: <CAPgLHd-xJ4+5e5UMMeF4G6RtWAb=xxDZ_JKE9tNZn057Eym8jw@mail.gmail.com>
From: Kent Yoder <shpedoikal@gmail.com>
Date: Fri, 15 Mar 2013 16:21:30 -0500
Message-ID: <CAM0nabF3Bzw9mE39m605WA+pg8q2s_xAA2iTa44t-Q8fiz0UKA@mail.gmail.com>
Subject: Re: [PATCH -next] char/tpm/tpm_i2c_stm_st33: remove duplicated
 include from tpm_i2c_stm_st33.c
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: key@linux.vnet.ibm.com, mail@srajiv.net, tpmdd@selhorst.net,
        tpmdd@sirrix.com, yongjun_wei@trendmicro.com.cn,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 9:20 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Remove duplicated include.

 HI Wei, thanks for the patch. I've already staged the same patch for
inclusion in the next pull request for TPM drivers here:

https://github.com/shpedoikal/linux/commit/6c09a9f5fcb3955afbae2e5a279c5d23481aab77

Thanks,
Kent

> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/char/tpm/tpm_i2c_stm_st33.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
> index 1f5f71e..4e42c62 100644
> --- a/drivers/char/tpm/tpm_i2c_stm_st33.c
> +++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
> @@ -36,7 +36,6 @@
>  #include <linux/i2c.h>
>  #include <linux/fs.h>
>  #include <linux/miscdevice.h>
> -#include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/delay.h>
>  #include <linux/init.h>
> @@ -50,7 +49,6 @@
>  #include <linux/uaccess.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> -#include <linux/sched.h>
>
>  #include "tpm.h"
>  #include "tpm_i2c_stm_st33.h"
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
