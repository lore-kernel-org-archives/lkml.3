Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaGBQYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:24:22 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:59133 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaGBQYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:24:20 -0400
Date: Wed, 2 Jul 2014 19:24:08 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] kvm: Add macro VMX_APIC_ACCESS_PAGE_ADDR
Message-ID: <20140702162408.GB4399@minantech.com>
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com>
 <1404291637-15048-3-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404291637-15048-3-git-send-email-tangchen@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 05:00:35PM +0800, Tang Chen wrote:
> Define guest phys_addr of apic access page.
> ---
>  arch/x86/include/asm/vmx.h | 2 +-
>  arch/x86/kvm/svm.c         | 3 ++-
>  arch/x86/kvm/vmx.c         | 7 ++++---
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 7004d21..c4672d1 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -422,7 +422,7 @@ enum vmcs_field {
>  #define VMX_EPT_DIRTY_BIT				(1ull << 9)
>  
>  #define VMX_EPT_IDENTITY_PAGETABLE_ADDR		0xfffbc000ul
> -
> +#define VMX_APIC_ACCESS_PAGE_ADDR		0xfee00000ull
>  
It has nothing to do with VMX and there is already define for that: APIC_DEFAULT_PHYS_BASE

--
			Gleb.
