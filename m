Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbbAIN6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:58:32 -0500
Received: from mga03.intel.com ([134.134.136.65]:24577 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbbAIN6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:58:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="438511175"
From: "Wu, Feng" <feng.wu@intel.com>
To: "joro@8bytes.org" <joro@8bytes.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 00/26] Add VT-d Posted-Interrupts support
Thread-Topic: [v3 00/26] Add VT-d Posted-Interrupts support
Thread-Index: AQHQLApJZJIaOUt9U0eHaK1MrKMJ9Jy3z2hA
Date: Fri, 9 Jan 2015 13:58:20 +0000
Message-ID: <E959C4978C3B6342920538CF579893F002336FD8@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
 <E959C4978C3B6342920538CF579893F002327907@SHSMSX104.ccr.corp.intel.com>
 <20150109124616.GB17298@8bytes.org>
In-Reply-To: <20150109124616.GB17298@8bytes.org>
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
> From: joro@8bytes.org [mailto:joro@8bytes.org]
> Sent: Friday, January 09, 2015 8:46 PM
> To: Wu, Feng
> Cc: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; x86@kernel.org;
> gleb@kernel.org; pbonzini@redhat.com; dwmw2@infradead.org;
> alex.williamson@redhat.com; jiang.liu@linux.intel.com; eric.auger@linaro.org;
> linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org;
> kvm@vger.kernel.org
> Subject: Re: [v3 00/26] Add VT-d Posted-Interrupts support
> 
> Hi Feng,
> 
> On Tue, Jan 06, 2015 at 01:10:19AM +0000, Wu, Feng wrote:
> > Ping...
> >
> > Hi Joerg & David,
> >
> > Could you please have a look at the IOMMU part of this series (patch 02 - 04,
> patch 06 - 09 , patch 26)?
> >
> > Hi Thomas, Ingo, & Peter,
> >
> > Could you please have a look at this series, especially for patch 01, 05, 21?
> 
> I fear this conflicts somewhat with the irq-domain patches from Jiang
> Liu. Once we worked this out (should happen soon) I'll have a look at
> the VT-d posted interrupt patches.
> 
> Regards,
> 
> 	Joerg

Thanks a lot for your feedback on this. In fact, my patches is based on Jiang Liu's
irq-domain patches and has been discussed with Jiang offline. So I don't think
it will conflicts with Jiang's work. Anyway, any comments are welcome!

Thanks,
Feng

