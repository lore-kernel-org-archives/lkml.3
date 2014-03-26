Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaCZHXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 03:23:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:52655 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbaCZHXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 03:23:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,734,1389772800"; 
   d="scan'208";a="499724613"
From: "Wu, Feng" <feng.wu@intel.com>
To: Peter Wu <peter@lekensteyn.nl>, Gleb Natapov <gleb@kernel.org>
CC: Venkatesh Srinivas <venkateshs@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: RE: GPF in intel_pmu_lbr_reset() with qemu -cpu host
Thread-Topic: GPF in intel_pmu_lbr_reset() with qemu -cpu host
Thread-Index: AQHPRho8rj9hNwUvg0mhYaGEbZ8B5Zry+/Dw
Date: Wed, 26 Mar 2014 07:23:04 +0000
Message-ID: <E959C4978C3B6342920538CF579893F001E80FC4@SHSMSX104.ccr.corp.intel.com>
References: <4055058.qLAukpngnj@al> <1558917.OgpeoK0IhF@al>
 <20140322122758.GA4292@minantech.com> <7070151.NcmQcQO4az@al>
In-Reply-To: <7070151.NcmQcQO4az@al>
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
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On
> Behalf Of Peter Wu
> Sent: Sunday, March 23, 2014 6:00 AM
> To: Gleb Natapov
> Cc: Venkatesh Srinivas; Peter Zijlstra; Ingo Molnar; Andi Kleen; Linux Kernel
> Developers List; H. Peter Anvin; kvm@vger.kernel.org; Paolo Bonzini
> Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
> 
> On Saturday 22 March 2014 14:27:59 Gleb Natapov wrote:
> > > but now I have a NULL dereference (in rapl_pmu_init). Previously, when
> > > `-cpu SandyBridge` was passed to qemu, it would show this:
> > >
> > >     [    0.016995] Performance Events: unsupported p6 CPU model 42
> no PMU driver, software events only.
> > >
> > > The same NULL pointer deref would be visible (slightly different
> > > addresses, but the Code lines are equal). With `-host`, the NULL deref
> > > with `-cpu host` contains:
> > >
> > >     [    0.016445] Performance Events: 16-deep LBR, IvyBridge events,
> Intel PMU driver.
> > >
> > > Full dmesg below.
> > >
> > I am confused. Do you see crash now with -cpu SandyBridge and -cpu host, or
> -cpu host only?
> 
> The RAPL crash is seen with both SandyBridge and host, I mentioned SB
> because that environment should be more constant than "host" (which
> depends on the CPU you have on, well, the host).
> 
> Peter

Is there a solution for this issue right now? I also met this GPF crash.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,
Feng
