Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbbAMDUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 22:20:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbbAMDUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 22:20:10 -0500
Date: Tue, 13 Jan 2015 03:27:33 +0008
From: Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH RESEND 1/1] X86: Mark the Hyper-V clocksource as being
 continuous
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: x86@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        tglx@linutronix.de, hpa@zytor.com,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        stable <stable@vger.kernel.org>
Message-Id: <1421119173.4765.0@smtp.corp.redhat.com>
In-Reply-To: <1421108762-3331-1-git-send-email-kys@microsoft.com>
References: <1421108762-3331-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, Jan 13, 2015 at 8:26 AM, K. Y. Srinivasan <kys@microsoft.com> 
wrote:
> The Hyper-V clocksource is continuous; mark it accordingly.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: stable <stable@vger.kernel.org>
> ---
>  arch/x86/kernel/cpu/mshyperv.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Acked-by: Jason Wang <jasowang@redhat.com>
> 
> diff --git a/arch/x86/kernel/cpu/mshyperv.c 
> b/arch/x86/kernel/cpu/mshyperv.c
> index a450373..939155f 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -107,6 +107,7 @@ static struct clocksource hyperv_cs = {
>  	.rating		= 400, /* use this when running on Hyperv*/
>  	.read		= read_hv_clock,
>  	.mask		= CLOCKSOURCE_MASK(64),
> +	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
>  };
>  
>  static void __init ms_hyperv_init_platform(void)
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

