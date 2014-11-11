Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaKKNDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:03:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:44442 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbaKKNC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:02:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="605911953"
From: "Wu, Feng" <feng.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC: "gleb@kernel.org" <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [PATCH 05/13] KVM: Update IRTE according to guest interrupt
 configuration changes
Thread-Topic: RE: [PATCH 05/13] KVM: Update IRTE according to guest
 interrupt configuration changes
Thread-Index: Ac/9r7XyGvSfd0JbSmKSr1frQIXFpA==
Date: Tue, 11 Nov 2014 13:02:14 +0000
Message-ID: <E959C4978C3B6342920538CF579893F0022700C3@SHSMSX104.ccr.corp.intel.com>
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
> Sent: Tuesday, November 11, 2014 7:02 PM
> To: Wu, Feng; Alex Williamson
> Cc: gleb@kernel.org; dwmw2@infradead.org; joro@8bytes.org;
> tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; x86@kernel.org;
> kvm@vger.kernel.org; iommu@lists.linux-foundation.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 05/13] KVM: Update IRTE according to guest interrupt
> configuration changes
> 
> 
> 
> On 11/11/2014 10:20, Wu, Feng wrote:
> > > Since legacy KVM device assignment is effectively deprecated, have you
> > > considered how we might do this with VFIO?  Thanks,
> >
> > I haven't thought about how to enable this in VFIO so far. I think I can continue
> to
> > implement that if needed after this patch set is finished. What do you think of
> this?
> 
> Hi Feng,
> 
> we are not applying new features to legacy KVM device assignment, since
> it is unsafe (it does not honor ACS).
> 
> I and Alex can help you with designing a way to interface VFIO with KVM
> posted interrupts.  Give us a few days to study these patches more, or
> feel free to request comments if you have ideas about it yourself.
> 
> Paolo

Okay, then I will put some efforts on getting familiar with VFIO mechanism. If
You have any questions about these patches, we can discuss it together.

Thanks,
Feng
