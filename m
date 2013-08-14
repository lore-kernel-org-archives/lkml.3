Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab3HNAvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 20:51:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:34659 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab3HNAvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 20:51:49 -0400
Message-ID: <1376441474.4255.39.camel@pasglop>
Subject: Re: [PATCH 02/10] KVM: PPC: reserve a capability number for
 multitce support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Date: Wed, 14 Aug 2013 10:51:14 +1000
In-Reply-To: <1375332272-22176-3-git-send-email-aik@ozlabs.ru>
References: <1375332272-22176-1-git-send-email-aik@ozlabs.ru>
	 <1375332272-22176-3-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 14:44 +1000, Alexey Kardashevskiy wrote:
> This is to reserve a capablity number for upcoming support
> of H_PUT_TCE_INDIRECT and H_STUFF_TCE pseries hypercalls
> which support mulptiple DMA map/unmap operations per one call.

Gleb, any chance you can put this (and the next one) into a tree to
"lock in" the numbers ?

I've been wanting to apply the whole series to powerpc-next, that's
stuff has been simmering for way too long and is in a good enough shape
imho, but I need the capabilities and ioctl numbers locked in your tree
first.

Cheers,
Ben.

> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> Changes:
> 2013/07/16:
> * changed the number
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  include/uapi/linux/kvm.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index acccd08..99c2533 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -667,6 +667,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_PPC_RTAS 91
>  #define KVM_CAP_IRQ_XICS 92
>  #define KVM_CAP_ARM_EL1_32BIT 93
> +#define KVM_CAP_SPAPR_MULTITCE 94
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  


