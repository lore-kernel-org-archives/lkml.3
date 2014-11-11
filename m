Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaKKGkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 01:40:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:33359 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbaKKGkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 01:40:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,359,1413270000"; 
   d="scan'208";a="620391662"
From: "Wu, Feng" <feng.wu@intel.com>
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: several messages
Thread-Topic: several messages
Thread-Index: AQHP/Vc8lYm08QhisUevl9lC05z135xa+RoA
Date: Tue, 11 Nov 2014 06:37:42 +0000
Message-ID: <E959C4978C3B6342920538CF579893F00226E47F@SHSMSX104.ccr.corp.intel.com>
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
 <1415600812-27773-14-git-send-email-feng.wu@intel.com>
 <alpine.DEB.2.11.1411101913340.3935@nanos> <5461745F.2080703@linux.intel.com>
In-Reply-To: <5461745F.2080703@linux.intel.com>
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
> From: Jiang Liu [mailto:jiang.liu@linux.intel.com]
> Sent: Tuesday, November 11, 2014 10:29 AM
> To: Thomas Gleixner; Wu, Feng
> Cc: gleb@kernel.org; pbonzini@redhat.com; David Woodhouse;
> joro@8bytes.org; mingo@redhat.com; H. Peter Anvin; x86@kernel.org;
> kvm@vger.kernel.org; iommu@lists.linux-foundation.org; LKML
> Subject: Re: several messages
> 
> On 2014/11/11 2:15, Thomas Gleixner wrote:
> > On Mon, 10 Nov 2014, Feng Wu wrote:
> >
> >> VT-d Posted-Interrupts is an enhancement to CPU side Posted-Interrupt.
> >> With VT-d Posted-Interrupts enabled, external interrupts from
> >> direct-assigned devices can be delivered to guests without VMM
> >> intervention when guest is running in non-root mode.
> >
> > Can you please talk to Jiang and synchronize your work with his
> > refactoring of the x86 interrupt handling subsystem.
> >
> > I want this stuff cleaned up first before we add new stuff to it.
> Hi Thomas,
> 	Just talked with Feng, we will focused on refactor first and
> then add posted interrupt support.
> Regards!
> Gerry

No problem!

Thanks,
Feng

> 
> >
> > Thanks,
> >
> > 	tglx
> >
