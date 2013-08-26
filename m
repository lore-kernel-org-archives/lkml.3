Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3HZMiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:38:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab3HZMiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:38:04 -0400
Date: Mon, 26 Aug 2013 15:37:53 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: [PATCH 02/10] KVM: PPC: reserve a capability number for multitce
 support
Message-ID: <20130826123753.GA22977@redhat.com>
References: <1375332272-22176-1-git-send-email-aik@ozlabs.ru>
 <1375332272-22176-3-git-send-email-aik@ozlabs.ru>
 <1376441474.4255.39.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376441474.4255.39.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 10:51:14AM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2013-08-01 at 14:44 +1000, Alexey Kardashevskiy wrote:
> > This is to reserve a capablity number for upcoming support
> > of H_PUT_TCE_INDIRECT and H_STUFF_TCE pseries hypercalls
> > which support mulptiple DMA map/unmap operations per one call.
> 
> Gleb, any chance you can put this (and the next one) into a tree to
> "lock in" the numbers ?
> 
Applied it. Sorry for slow response, was on vocation and still go
through the email backlog.

> I've been wanting to apply the whole series to powerpc-next, that's
> stuff has been simmering for way too long and is in a good enough shape
> imho, but I need the capabilities and ioctl numbers locked in your tree
> first.
> 
> Cheers,
> Ben.
> 
> > Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> > ---
> > Changes:
> > 2013/07/16:
> > * changed the number
> > 
> > Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> > ---
> >  include/uapi/linux/kvm.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index acccd08..99c2533 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -667,6 +667,7 @@ struct kvm_ppc_smmu_info {
> >  #define KVM_CAP_PPC_RTAS 91
> >  #define KVM_CAP_IRQ_XICS 92
> >  #define KVM_CAP_ARM_EL1_32BIT 93
> > +#define KVM_CAP_SPAPR_MULTITCE 94
> >  
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
