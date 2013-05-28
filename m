Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab3E1XfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:35:25 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:34427
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759267Ab3E1XfX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:35:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Date: Tue, 28 May 2013 18:35:15 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
To: Alexey Kardashevskiy <aik@ozlabs.ru>
CC: David Gibson <david@gibson.dropbear.id.au>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm-ppc@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        <linuxppc-dev@lists.ozlabs.org>
References: <1369763138.18630.3@snotra> <51A53E20.3020205@ozlabs.ru>
In-Reply-To: <51A53E20.3020205@ozlabs.ru> (from aik@ozlabs.ru on Tue May 28
	18:30:40 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1369784115.18630.27@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 06:30:40 PM, Alexey Kardashevskiy wrote:
> >> >>> @@ -939,6 +940,9 @@ struct kvm_s390_ucas_mapping {
> >> >>> #define KVM_GET_DEVICE_ATTR      _IOW(KVMIO,  0xe2, struct
> >> >>> kvm_device_attr)
> >> >>> #define KVM_HAS_DEVICE_ATTR      _IOW(KVMIO,  0xe3, struct
> >> >>> kvm_device_attr)
> >> >>>
> >> >>> +/* ioctl for SPAPR TCE IOMMU */
> >> >>> +#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xe4, struct
> >> >>> kvm_create_spapr_tce_iommu)
> >> >>
> >> >> Shouldn't this go under the vm ioctl section?
> >>
> >>
> >> The KVM_CREATE_SPAPR_TCE_IOMMU ioctl (the version for emulated  
> devices) is
> >> in this section so I decided to keep them together. Wrong?
> >
> > You decided to keep KVM_CREATE_SPAPR_TCE_IOMMU together with
> > KVM_CREATE_SPAPR_TCE_IOMMU?
> 
> Yes.

Sigh.  That's the same thing repeated.  There's only one IOCTL.   
Nothing is being "kept together".

-Scott
