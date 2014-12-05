Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaLELww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:52:52 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39957 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaLELwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:52:51 -0500
Date: Fri, 5 Dec 2014 17:22:35 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Athira Lekshmi <andnlnbn18@gmail.com>
Cc: gregkh@linuxfoundation.org, eunb.song@samsung.com,
        paul.gortmaker@windriver.com, gulsah.1004@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers:staging:octeon: Fixed checkpatch warning
Message-ID: <20141205115235.GA8884@sudip-PC>
References: <1417776922-2765-1-git-send-email-andnlnbn18@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417776922-2765-1-git-send-email-andnlnbn18@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 04:25:22PM +0530, Athira Lekshmi wrote:
> Fixed the checkpatch warning:
> Missing a blank line after declarations

this is not applying to next-20141204.

sudip

> 
> Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
> ---
>  drivers/staging/octeon/ethernet-rx.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
> index 44e372f..220106e 100644
> --- a/drivers/staging/octeon/ethernet-rx.c
> +++ b/drivers/staging/octeon/ethernet-rx.c
> @@ -84,6 +84,7 @@ static int cvm_irq_cpu;
>  static void cvm_oct_enable_napi(void *_)
>  {
>  	int cpu = smp_processor_id();
> +
>  	napi_schedule(&cvm_oct_napi[cpu].napi);
>  }
>  
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
