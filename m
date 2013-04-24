Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab3DXLVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:21:33 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:55902
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752060Ab3DXLVc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:21:32 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: RE: [PATCH 2/3 v14] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Thread-Topic: [PATCH 2/3 v14] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Thread-Index: AQHOP90uclGpGfD1QUaX06kTxa8S0pjjz/0AgAAHY6CAAVwxAIAACBLg
Date: Wed, 24 Apr 2013 11:21:14 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D4B820D@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1366691726-9023-1-git-send-email-Varun.Sethi@freescale.com>
 <1366691726-9023-2-git-send-email-Varun.Sethi@freescale.com>
 <20130423133837.GG17148@8bytes.org>
 <C5ECD7A89D1DC44195F34B25E172658D4B4D9A@039-SN2MPN1-011.039d.mgd.msft.net>
 <20130424105117.GI17148@8bytes.org>
In-Reply-To: <20130424105117.GI17148@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.53]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Wednesday, April 24, 2013 4:21 PM
> To: Sethi Varun-B16395
> Cc: iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org;
> linux-kernel@vger.kernel.org; galak@kernel.crashing.org;
> benh@kernel.crashing.org; Yoder Stuart-B08248; Wood Scott-B07421
> Subject: Re: [PATCH 2/3 v14] iommu/fsl: Add additional iommu attributes
> required by the PAMU driver.
> 
> On Tue, Apr 23, 2013 at 02:10:25PM +0000, Sethi Varun-B16395 wrote:
> > I think it's fine to have the header under linux, actually I also the
> > intel-iommu header under linux.
> 
> Yes, the difference is that VT-d runs on x86 and on ia64. So there is no
> single arch where the header could be placed. The amd-iommu.h file on the
> other hand is x86 only and should also be moved to asm/, as I just found
> out :)
> 
> And as long as PAMU is only needed on a single architecture the header
> should also be arch-specific. If that changes someday the header can be
> moved to a generic place.
> 
Ok, I will post the next version of the patch set.

-Varun


