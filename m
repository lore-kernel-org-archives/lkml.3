Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaKLJXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:23:32 -0500
Received: from mga14.intel.com ([192.55.52.115]:54780 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbaKLJX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:23:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="415286518"
From: "Wu, Feng" <feng.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC: "gleb@kernel.org" <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 05/13] KVM: Update IRTE according to guest interrupt
 configuration changes
Thread-Topic: [PATCH 05/13] KVM: Update IRTE according to guest interrupt
 configuration changes
Thread-Index: Ac/9kLfHSOSyagtOQAqEsc5J81STLgAyIb0DAAAcBYA=
Date: Wed, 12 Nov 2014 09:19:55 +0000
Message-ID: <E959C4978C3B6342920538CF579893F00227680F@SHSMSX104.ccr.corp.intel.com>
References: <E959C4978C3B6342920538CF579893F00226EF05@SHSMSX104.ccr.corp.intel.com>
 <5461EC99.1000101@redhat.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0ABDBB25@SHSMSX104.ccr.corp.intel.com>
 <546324F4.8010002@redhat.com>
In-Reply-To: <546324F4.8010002@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAC9NePs016018



> -----Original Message-----
> From: Paolo Bonzini [mailto:pbonzini@redhat.com]
> Sent: Wednesday, November 12, 2014 5:14 PM
> To: Zhang, Yang Z; Wu, Feng; Alex Williamson
> Cc: gleb@kernel.org; dwmw2@infradead.org; joro@8bytes.org;
> tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; x86@kernel.org;
> kvm@vger.kernel.org; iommu@lists.linux-foundation.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 05/13] KVM: Update IRTE according to guest interrupt
> configuration changes
> 
> 
> 
> On 12/11/2014 04:42, Zhang, Yang Z wrote:
> > Personally, I think this feature will be helpful to the legacy device
> > assignment. Agree, vfio is the right solution for future feature
> > enabling. But the old kvm without the good vfio supporting is still
> > used largely today. The user really looking for this feature but they
> > will not upgrade their kernel. It's easy for us to backport this
> > feature to old kvm with the legacy device assignment, but it is
> > impossible to backport the whole vfio.
> 
> You can certainly backport these patches to distros that do not have
> VFIO.  But upstream we should work on VFIO first.  VFIO has feature
> parity with legacy device assignment, and adding a new feature that is
> not in VFIO would be a bad idea.
> 
> By the way, do you have benchmark results for it?  We have not been able
> to see any performance improvement for APICv on e.g. netperf.

Do you mean benchmark results for APICv itself or VT-d Posted-Interrtups?

Thanks,
Feng

> 
> Paolo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
