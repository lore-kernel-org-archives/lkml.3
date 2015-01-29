Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbbA2IiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:38:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:13364 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbbA2IiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:38:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,485,1418112000"; 
   d="scan'208";a="669581904"
From: "Wu, Feng" <feng.wu@intel.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 02/26] iommu: Add new member capability to struct
 irq_remap_ops
Thread-Topic: [v3 02/26] iommu: Add new member capability to struct
 irq_remap_ops
Thread-Index: AQHQOw5JW9p0VEbddUWuoZg3OmvZ+5zWxnFg
Date: Thu, 29 Jan 2015 08:34:11 +0000
Message-ID: <E959C4978C3B6342920538CF579893F00238958B@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
	 <1418397300-10870-3-git-send-email-feng.wu@intel.com>
 <1422458557.5293.51.camel@infradead.org>
In-Reply-To: <1422458557.5293.51.camel@infradead.org>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0T8cLvw013013



> -----Original Message-----
> From: David Woodhouse [mailto:dwmw2@infradead.org]
> Sent: Wednesday, January 28, 2015 11:23 PM
> To: Wu, Feng
> Cc: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; x86@kernel.org;
> gleb@kernel.org; pbonzini@redhat.com; joro@8bytes.org;
> alex.williamson@redhat.com; jiang.liu@linux.intel.com; eric.auger@linaro.org;
> linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org;
> kvm@vger.kernel.org
> Subject: Re: [v3 02/26] iommu: Add new member capability to struct
> irq_remap_ops
> 
> On Fri, 2014-12-12 at 23:14 +0800, Feng Wu wrote:
> > This patch adds a new member capability to struct irq_remap_ops,
> > this new function ops can be used to check whether some
> > features are supported, such as VT-d Posted-Interrupts.
> 
> > +	/* Check some capability is supported */
> > +	bool (*capability)(enum irq_remap_cap);
> > +
> 
> Does this need to be a function call? Or could we just have a set of
> flags in the irq_remap_ops instead, with less overhead to check them?

Sounds a good idea, I will follow this in the next post! Thanks for the comments!

Thanks,
Feng

> 
> --
> David Woodhouse                            Open Source Technology
> Centre
> David.Woodhouse@intel.com                              Intel
> Corporation
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
