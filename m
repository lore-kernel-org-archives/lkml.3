Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3J3J2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 05:28:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab3J3J2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 05:28:20 -0400
Date: Wed, 30 Oct 2013 11:27:24 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 01/11] asmlinkage, kvm: Make kvm_rebooting visible
Message-ID: <20131030092723.GC4651@redhat.com>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
 <1382458346-24811-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382458346-24811-2-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 09:12:16AM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> kvm_rebooting is referenced from assembler code, thus
> needs to be visible.
> 
> Cc: gleb@redhat.com
> Cc: pbonzini@redhat.com
> Cc: kvm@vger.kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Gleb Natapov <gleb@redhat.com>

> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a9dd682..6ca3564 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -95,7 +95,7 @@ static void hardware_disable_all(void);
>  
>  static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
>  
> -bool kvm_rebooting;
> +__visible bool kvm_rebooting;
>  EXPORT_SYMBOL_GPL(kvm_rebooting);
>  
>  static bool largepages_enabled = true;
> -- 
> 1.8.3.1

--
			Gleb.
