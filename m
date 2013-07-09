Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab3GIPgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:36:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab3GIPgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:36:03 -0400
Message-ID: <51DC2DDA.6040408@suse.de>
Date: Tue, 09 Jul 2013 17:35:54 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120306 Thunderbird/10.0.3
MIME-Version: 1.0
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 2/8] KVM: PPC: reserve a capability and ioctl numbers
 for realmode VFIO
References: <1372309356-28320-1-git-send-email-aik@ozlabs.ru> <1372309356-28320-3-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1372309356-28320-3-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 07:02 AM, Alexey Kardashevskiy wrote:
> Signed-off-by: Alexey Kardashevskiy<aik@ozlabs.ru>
> ---
>   include/uapi/linux/kvm.h |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 970b1f5..0865c01 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -667,6 +667,7 @@ struct kvm_ppc_smmu_info {
>   #define KVM_CAP_PPC_RTAS 91
>   #define KVM_CAP_IRQ_XICS 92
>   #define KVM_CAP_SPAPR_MULTITCE 93
> +#define KVM_CAP_SPAPR_TCE_IOMMU 94
>
>   #ifdef KVM_CAP_IRQ_ROUTING
>
> @@ -923,6 +924,7 @@ struct kvm_s390_ucas_mapping {
>   /* Available with KVM_CAP_PPC_ALLOC_HTAB */
>   #define KVM_PPC_ALLOCATE_HTAB	  _IOWR(KVMIO, 0xa7, __u32)
>   #define KVM_CREATE_SPAPR_TCE	  _IOW(KVMIO,  0xa8, struct kvm_create_spapr_tce)
> +#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xaf, struct kvm_create_spapr_tce_iommu)

Please order them by number.

Alex

>   /* Available with KVM_CAP_RMA */
>   #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
>   /* Available with KVM_CAP_PPC_HTAB_FD */

