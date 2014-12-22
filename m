Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbaLVOM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:12:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:35979 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810AbaLVOM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:12:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,624,1413270000"; 
   d="scan'208";a="627719192"
Date: Mon, 22 Dec 2014 22:13:18 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Wu, Feng" <feng.wu@intel.com>, "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>
Subject: Re: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
Message-ID: <20141222141318.GA12171@ywang-linux>
References: <E959C4978C3B6342920538CF579893F00230A5F8@SHSMSX104.ccr.corp.intel.com>
 <5494131E.9030505@redhat.com>
 <E959C4978C3B6342920538CF579893F00230D036@SHSMSX104.ccr.corp.intel.com>
 <549576C7.4030800@redhat.com>
 <E959C4978C3B6342920538CF579893F0023103FB@SHSMSX104.ccr.corp.intel.com>
 <5497E41F.50301@redhat.com>
 <E959C4978C3B6342920538CF579893F002310D51@SHSMSX104.ccr.corp.intel.com>
 <5497FB50.1080606@redhat.com>
 <E959C4978C3B6342920538CF579893F002310DAB@SHSMSX104.ccr.corp.intel.com>
 <5497FF38.3040503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5497FF38.3040503@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 12:23:36PM +0100, Paolo Bonzini wrote:
> 
> 
> On 22/12/2014 12:17, Wu, Feng wrote:
> >> Yes, and those need not be accelerated.  But what if you set
> >> affinity to a single CPU?
> >
> > How do I set affinity to a single CPU if guest configure a lowest
> > priority interrupt? Thanks a lot!
> 
> I mean if the guest (via irqbalance and /proc/irq/) configures affinity
> to a single vCPU.  In that case, you can use PI.
> 

The problem is we still need to support PI with lowest priority delivery mode
even if guest does not configure irq affinity via /proc/irq/. Don't we?

Thanks
-Yong

