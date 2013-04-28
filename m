Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3D1KSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 06:18:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab3D1KSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 06:18:07 -0400
Date: Sun, 28 Apr 2013 13:18:01 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Chegu Vinod <chegu_vinod@hp.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Increase the "hard" max VCPU limit
Message-ID: <20130428101801.GG30504@redhat.com>
References: <1367112664-19862-1-git-send-email-chegu_vinod@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367112664-19862-1-git-send-email-chegu_vinod@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 06:31:04PM -0700, Chegu Vinod wrote:
> KVM guests today use 8bit APIC ids allowing for 256 ID's. Reserving one
> ID for Broadcast interrupts should leave 255 ID's. In case of KVM there
> is no need for reserving another ID for IO-APIC so the hard max limit for
> VCPUS can be increased from 254 to 255. (This was confirmed by Gleb Natapov
> http://article.gmane.org/gmane.comp.emulators.kvm.devel/99713  )
> 
> Signed-off-by: Chegu Vinod <chegu_vinod@hp.com>
Applied, thanks.

> ---
>  arch/x86/include/asm/kvm_host.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4979778..bc57bfa 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -31,7 +31,7 @@
>  #include <asm/msr-index.h>
>  #include <asm/asm.h>
>  
> -#define KVM_MAX_VCPUS 254
> +#define KVM_MAX_VCPUS 255
>  #define KVM_SOFT_MAX_VCPUS 160
>  #define KVM_USER_MEM_SLOTS 125
>  /* memory slots that are not exposed to userspace */
> -- 
> 1.7.1

--
			Gleb.
