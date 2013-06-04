Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab3FDGyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:54:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:35795 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758811Ab3FDGyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:54:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,798,1363158000"; 
   d="scan'208";a="250321911"
Message-ID: <51AD8F07.5060706@intel.com>
Date: Tue, 04 Jun 2013 14:53:59 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, fenghua.yu@intel.com
Subject: Re: [PATCH] code clean in __flush_tlb_one()
References: <51AD8902.60603@linux.vnet.ibm.com>
In-Reply-To: <51AD8902.60603@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 02:28 PM, Michael Wang wrote:
> Remove the extra space in __flush_tlb_one()

It even don't need a reviewed-by. :)

Thanks!
> 
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Alex Shi <alex.shi@intel.com>
> CC: Fenghua Yu <fenghua.yu@intel.com>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/tlbflush.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/tlbflush.h
> b/arch/x86/include/asm/tlbflush.h
> index 50a7fc0..cf51200 100644
> --- a/arch/x86/include/asm/tlbflush.h
> +++ b/arch/x86/include/asm/tlbflush.h
> @@ -62,7 +62,7 @@ static inline void __flush_tlb_all(void)
> 
>  static inline void __flush_tlb_one(unsigned long addr)
>  {
> -		__flush_tlb_single(addr);
> +	__flush_tlb_single(addr);
>  }
> 
>  #define TLB_FLUSH_ALL	-1UL
> 


-- 
Thanks
    Alex
