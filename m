Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab3A1O7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:59:40 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:44610
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754915Ab3A1O7e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:59:34 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dI9371Id6eah542I1432I4015Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1155h)
X-WSS-ID: 0MHCCB1-01-394-02
X-M-MSG: 
From: "Kinney, Steven" <Steven.Kinney@amd.com>
To: Joerg Roedel <joro@8bytes.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Myron Stowe <myron.stowe@redhat.com>, Hiroshi DOYU <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Kosina <jkosina@suse.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: RE: [PATCH 1/3] AMD x86 quirks: Quirk for enabling IOMMUv2 PC
 feature
Thread-Topic: [PATCH 1/3] AMD x86 quirks: Quirk for enabling IOMMUv2 PC
 feature
Thread-Index: AQHN+BTdjn95QA9wrkuUYh1WbqV225hfPC0A//+ifvA=
Date: Mon, 28 Jan 2013 14:59:25 +0000
Message-ID: <57D41218901B4442B4AFF404D21591163C2D4E@sausexdag02.amd.com>
References: <1358799658-6236-1-git-send-email-steven.kinney@amd.com>
 <1358799658-6236-2-git-send-email-steven.kinney@amd.com>
 <20130128142928.GZ25591@8bytes.org>
In-Reply-To: <20130128142928.GZ25591@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.236.70.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

                       It was disabled for a reason that does not pertain to IOMMUv2 PC static counts (reading from the ICounter associated with the selected bank/counter).  Testing with perf shows expected results.

Thanks,

Steve

-----Original Message-----
From: Joerg Roedel [mailto:joro@8bytes.org] 
Sent: Monday, January 28, 2013 8:29 AM
To: Kinney, Steven
Cc: Thomas Gleixner; Ingo Molnar; H. Peter Anvin; x86@kernel.org; Bjorn Helgaas; Greg Kroah-Hartman; Sebastian Andrzej Siewior; Myron Stowe; Hiroshi DOYU; Stephen Warren; Jiri Kosina; Kukjin Kim; linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org; Peter Zijlstra; Paul Mackerras; Arnaldo Carvalho de Melo; Thomas Renninger; Andi Kleen; Cyrill Gorcunov
Subject: Re: [PATCH 1/3] AMD x86 quirks: Quirk for enabling IOMMUv2 PC feature

On Mon, Jan 21, 2013 at 02:20:56PM -0600, Steven L. Kinney wrote:
> From: "Steven L. Kinney" <steven.kinney@amd.com>
> 
> Original code base by Andreas Herrmann at AMD with minor changes.

Why is it safe to enable this feature when it was disabled by BIOS? Was it disabled for no reason?


	Joerg



