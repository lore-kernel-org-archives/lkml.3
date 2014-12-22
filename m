Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaLVLEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:04:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:58665 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbaLVLEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:04:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,623,1413270000"; 
   d="scan'208";a="627642311"
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
Thread-Index: AQHQHcm59RgV+7h/5Ui6lHzT31JJLZybcbcw
Date: Mon, 22 Dec 2014 11:04:25 +0000
Message-ID: <E959C4978C3B6342920538CF579893F002310D51@SHSMSX104.ccr.corp.intel.com>
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
In-Reply-To: <5497E41F.50301@redhat.com>
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
> Sent: Monday, December 22, 2014 5:28 PM
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
> On 22/12/2014 05:48, Wu, Feng wrote:
> > Do you mean we don't support Lowest priority interrupts? As I mentioned
> before,
> > Lowest priority interrupts is widely used in Linux, so I think supporting lowest
> priority
> > interrupts is very important for Linux guest OS. Do you have any
> ideas/suggestions about
> > how to support Lowest priority interrupts for PI? Thanks a lot!
> 
> Can you support them only if the destination is a single CPU?

Sorry, I am not quite understand this. I still don't understand the "single CPU" here.
Lowest priority interrupts always have a cpumask which contains multiple CPU.

Thanks,
Feng

> 
> Paolo
