Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaLVLRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:17:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:6834 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbaLVLRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:17:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="432085994"
From: "Wu, Feng" <feng.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
Thread-Topic: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu()
 for VT-d PI
Thread-Index: AQHQHdeEIi/lpOcw+EuisuFJCtkFwpybdYkA
Date: Mon, 22 Dec 2014 11:17:30 +0000
Message-ID: <E959C4978C3B6342920538CF579893F002310DAB@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
	<1418397300-10870-14-git-send-email-feng.wu@intel.com>
	<A9667DDFB95DB7438FA9D7D576C3D87E0AC048A2@SHSMSX104.ccr.corp.intel.com>
	<549307A5.3060305@redhat.com>
	<E959C4978C3B6342920538CF579893F00230A5F8@SHSMSX104.ccr.corp.intel.com>
	<5494131E.9030505@redhat.com>
 <E959C4978C3B6342920538CF579893F00230D036@SHSMSX104.ccr.corp.intel.com>
 <549576C7.4030800@redhat.com>
 <E959C4978C3B6342920538CF579893F0023103FB@SHSMSX104.ccr.corp.intel.com>
 <5497E41F.50301@redhat.com>
 <E959C4978C3B6342920538CF579893F002310D51@SHSMSX104.ccr.corp.intel.com>
 <5497FB50.1080606@redhat.com>
In-Reply-To: <5497FB50.1080606@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Paolo Bonzini [mailto:pbonzini@redhat.com]
> Sent: Monday, December 22, 2014 7:07 PM
> To: Wu, Feng; Zhang, Yang Z; Thomas Gleixner; Ingo Molnar; H. Peter Anvin;
> x86@kernel.org; Gleb Natapov; dwmw2@infradead.org; joro@8bytes.org;
> Alex Williamson; Jiang Liu
> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org; KVM list;
> Eric Auger
> Subject: Re: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
> VT-d PI
> 
> 
> 
> On 22/12/2014 12:04, Wu, Feng wrote:
> > > Can you support them only if the destination is a single CPU?
> >
> > Sorry, I am not quite understand this. I still don't understand the "single CPU"
> here.
> > Lowest priority interrupts always have a cpumask which contains multiple
> CPU.
> 
> Yes, and those need not be accelerated.  But what if you set affinity to
> a single CPU?

How do I set affinity to a single CPU if guest configure a lowest priority interrupt? Thanks a lot!

Thanks,
Feng

> 
> Paolo
