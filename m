Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab3GIXfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 19:35:25 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64801 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab3GIXfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 19:35:22 -0400
Message-ID: <51DC9E32.8040109@ozlabs.ru>
Date: Wed, 10 Jul 2013 09:35:14 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 2/8] KVM: PPC: reserve a capability and ioctl numbers
 for realmode VFIO
References: <1372309356-28320-1-git-send-email-aik@ozlabs.ru> <1372309356-28320-3-git-send-email-aik@ozlabs.ru> <51DC2DDA.6040408@suse.de>
In-Reply-To: <51DC2DDA.6040408@suse.de>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 01:35 AM, Alexander Graf wrote:
> On 06/27/2013 07:02 AM, Alexey Kardashevskiy wrote:
>> Signed-off-by: Alexey Kardashevskiy<aik@ozlabs.ru>
>> ---
>>   include/uapi/linux/kvm.h |    2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 970b1f5..0865c01 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -667,6 +667,7 @@ struct kvm_ppc_smmu_info {
>>   #define KVM_CAP_PPC_RTAS 91
>>   #define KVM_CAP_IRQ_XICS 92
>>   #define KVM_CAP_SPAPR_MULTITCE 93
>> +#define KVM_CAP_SPAPR_TCE_IOMMU 94
>>
>>   #ifdef KVM_CAP_IRQ_ROUTING
>>
>> @@ -923,6 +924,7 @@ struct kvm_s390_ucas_mapping {
>>   /* Available with KVM_CAP_PPC_ALLOC_HTAB */
>>   #define KVM_PPC_ALLOCATE_HTAB      _IOWR(KVMIO, 0xa7, __u32)
>>   #define KVM_CREATE_SPAPR_TCE      _IOW(KVMIO,  0xa8, struct
>> kvm_create_spapr_tce)
>> +#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xaf, struct
>> kvm_create_spapr_tce_iommu)
> 
> Please order them by number.

Oh. Again :( We have had this discussion with Scott Wood here already.
Where _exactly_ do you want me to put it? Many sections, not really
ordered. Thank you.



-- 
Alexey
