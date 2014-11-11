Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaKKL5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:57:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaKKL5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:57:34 -0500
Message-ID: <5461EC99.1000101@redhat.com>
Date: Tue, 11 Nov 2014 12:01:45 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Wu, Feng" <feng.wu@intel.com>,
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
Subject: Re: [PATCH 05/13] KVM: Update IRTE according to guest interrupt configuration
 changes
References: <E959C4978C3B6342920538CF579893F00226EF05@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <E959C4978C3B6342920538CF579893F00226EF05@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/11/2014 10:20, Wu, Feng wrote:
> > Since legacy KVM device assignment is effectively deprecated, have you
> > considered how we might do this with VFIO?  Thanks,
> 
> I haven't thought about how to enable this in VFIO so far. I think I can continue to
> implement that if needed after this patch set is finished. What do you think of this?

Hi Feng,

we are not applying new features to legacy KVM device assignment, since
it is unsafe (it does not honor ACS).

I and Alex can help you with designing a way to interface VFIO with KVM
posted interrupts.  Give us a few days to study these patches more, or
feel free to request comments if you have ideas about it yourself.

Paolo
