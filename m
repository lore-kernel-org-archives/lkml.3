Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711AbaLCAco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:32:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428AbaLCAco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:32:44 -0500
Date: Tue, 2 Dec 2014 16:32:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Athira Lekshmi <andnlnbn18@gmail.com>
Cc: eunb.song@samsung.com, paul.gortmaker@windriver.com, gulsah.1004@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers:staging:octeon: Fixed checkpatch warning
Message-ID: <20141203003243.GA7317@kroah.com>
References: <1417239240-12190-1-git-send-email-andnlnbn18@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417239240-12190-1-git-send-email-andnlnbn18@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 11:04:00AM +0530, Athira Lekshmi wrote:
> Fixed the checkpatch warning:
> Missing a blank line after declarations
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

Why did you resend this, with no obvious reason why it was different
from the previous version?

I don't know what to apply, so I'm dropping both.  Please resend the
patch properly, and only once.

greg k-h
