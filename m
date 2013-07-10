Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab3GJK1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:27:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab3GJK1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:27:16 -0400
Subject: Re: [PATCH 2/8] KVM: PPC: reserve a capability and ioctl numbers for realmode VFIO
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <51DC9E32.8040109@ozlabs.ru>
Date: Wed, 10 Jul 2013 12:27:12 +0200
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <E8E3A724-7045-4B8F-BE29-29BAB41D68C2@suse.de>
References: <1372309356-28320-1-git-send-email-aik@ozlabs.ru> <1372309356-28320-3-git-send-email-aik@ozlabs.ru> <51DC2DDA.6040408@suse.de> <51DC9E32.8040109@ozlabs.ru>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10.07.2013, at 01:35, Alexey Kardashevskiy wrote:

> On 07/10/2013 01:35 AM, Alexander Graf wrote:
>> On 06/27/2013 07:02 AM, Alexey Kardashevskiy wrote:
>>> Signed-off-by: Alexey Kardashevskiy<aik@ozlabs.ru>
>>> ---
>>>  include/uapi/linux/kvm.h |    2 ++
>>>  1 file changed, 2 insertions(+)
>>> 
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index 970b1f5..0865c01 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -667,6 +667,7 @@ struct kvm_ppc_smmu_info {
>>>  #define KVM_CAP_PPC_RTAS 91
>>>  #define KVM_CAP_IRQ_XICS 92
>>>  #define KVM_CAP_SPAPR_MULTITCE 93
>>> +#define KVM_CAP_SPAPR_TCE_IOMMU 94
>>> 
>>>  #ifdef KVM_CAP_IRQ_ROUTING
>>> 
>>> @@ -923,6 +924,7 @@ struct kvm_s390_ucas_mapping {
>>>  /* Available with KVM_CAP_PPC_ALLOC_HTAB */
>>>  #define KVM_PPC_ALLOCATE_HTAB      _IOWR(KVMIO, 0xa7, __u32)
>>>  #define KVM_CREATE_SPAPR_TCE      _IOW(KVMIO,  0xa8, struct
>>> kvm_create_spapr_tce)
>>> +#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xaf, struct
>>> kvm_create_spapr_tce_iommu)
>> 
>> Please order them by number.
> 
> Oh. Again :( We have had this discussion with Scott Wood here already.
> Where _exactly_ do you want me to put it?

8 lines further down. With a comment saying when it's available. Also why is it af, not ad?

> Many sections, not really ordered. Thank you.

They should all be ordered inside of their own categories.


Alex

