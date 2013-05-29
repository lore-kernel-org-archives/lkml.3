Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab3E2AMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 20:12:41 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41861 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab3E2AMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 20:12:40 -0400
Message-ID: <51A547F0.8090406@ozlabs.ru>
Date: Wed, 29 May 2013 10:12:32 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: David Gibson <david@gibson.dropbear.id.au>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
References: <1369763138.18630.3@snotra> <51A53E20.3020205@ozlabs.ru> <1369784115.18630.27@snotra>
In-Reply-To: <1369784115.18630.27@snotra>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 09:35 AM, Scott Wood wrote:
> On 05/28/2013 06:30:40 PM, Alexey Kardashevskiy wrote:
>> >> >>> @@ -939,6 +940,9 @@ struct kvm_s390_ucas_mapping {
>> >> >>> #define KVM_GET_DEVICE_ATTR      _IOW(KVMIO,  0xe2, struct
>> >> >>> kvm_device_attr)
>> >> >>> #define KVM_HAS_DEVICE_ATTR      _IOW(KVMIO,  0xe3, struct
>> >> >>> kvm_device_attr)
>> >> >>>
>> >> >>> +/* ioctl for SPAPR TCE IOMMU */
>> >> >>> +#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xe4, struct
>> >> >>> kvm_create_spapr_tce_iommu)
>> >> >>
>> >> >> Shouldn't this go under the vm ioctl section?
>> >>
>> >>
>> >> The KVM_CREATE_SPAPR_TCE_IOMMU ioctl (the version for emulated
>> devices) is
>> >> in this section so I decided to keep them together. Wrong?
>> >
>> > You decided to keep KVM_CREATE_SPAPR_TCE_IOMMU together with
>> > KVM_CREATE_SPAPR_TCE_IOMMU?
>>
>> Yes.
> 
> Sigh.  That's the same thing repeated.  There's only one IOCTL.  Nothing is
> being "kept together".

Sorry, I meant this ioctl - KVM_CREATE_SPAPR_TCE.


-- 
Alexey
