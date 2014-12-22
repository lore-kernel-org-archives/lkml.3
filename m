Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaLVLH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:07:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbaLVLHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:07:54 -0500
Message-ID: <5497FB50.1080606@redhat.com>
Date: Mon, 22 Dec 2014 12:06:56 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Wu, Feng" <feng.wu@intel.com>, "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>
Subject: Re: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>	<1418397300-10870-14-git-send-email-feng.wu@intel.com>	<A9667DDFB95DB7438FA9D7D576C3D87E0AC048A2@SHSMSX104.ccr.corp.intel.com>	<549307A5.3060305@redhat.com>	<E959C4978C3B6342920538CF579893F00230A5F8@SHSMSX104.ccr.corp.intel.com>	<5494131E.9030505@redhat.com> <E959C4978C3B6342920538CF579893F00230D036@SHSMSX104.ccr.corp.intel.com> <549576C7.4030800@redhat.com> <E959C4978C3B6342920538CF579893F0023103FB@SHSMSX104.ccr.corp.intel.com> <5497E41F.50301@redhat.com> <E959C4978C3B6342920538CF579893F002310D51@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <E959C4978C3B6342920538CF579893F002310D51@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 22/12/2014 12:04, Wu, Feng wrote:
> > Can you support them only if the destination is a single CPU?
>
> Sorry, I am not quite understand this. I still don't understand the "single CPU" here.
> Lowest priority interrupts always have a cpumask which contains multiple CPU.

Yes, and those need not be accelerated.  But what if you set affinity to
a single CPU?

Paolo
