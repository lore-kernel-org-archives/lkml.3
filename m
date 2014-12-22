Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaLVDS5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 22:18:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:7381 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbaLVDS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 22:18:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,620,1413270000"; 
   d="scan'208";a="627504124"
Message-ID: <54978D9C.9070605@linux.intel.com>
Date: Mon, 22 Dec 2014 11:18:52 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: x86: kernel: apb_timer.c:  Remove unused function
References: <1419166698-2470-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1419166698-2470-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/21 20:58, Rickard Strandqvist wrote:
> Remove the function is_apbt_capable() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  arch/x86/kernel/apb_timer.c |    8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
> index b708738..6a7c23f 100644
> --- a/arch/x86/kernel/apb_timer.c
> +++ b/arch/x86/kernel/apb_timer.c
> @@ -135,14 +135,6 @@ static inline void apbt_clear_mapping(void)
>  	apbt_virt_address = NULL;
>  }
>  
> -/*
> - * APBT timer interrupt enable / disable
> - */
> -static inline int is_apbt_capable(void)
> -{
> -	return apbt_virt_address ? 1 : 0;
> -}
> -
>  static int __init apbt_clockevent_register(void)
>  {
>  	struct sfi_timer_table_entry *mtmr;
> 
Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
