Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3DWNCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:02:44 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:43469
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755961Ab3DWNCn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:02:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI9371I146fI542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joro@8bytes.org>
CC: "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH 1/3 v2] iommu: Move swap_pci_ref function to pci.h.
Thread-Topic: [PATCH 1/3 v2] iommu: Move swap_pci_ref function to pci.h.
Thread-Index: AQHOP90rLdZSjpgiUkm9R0ssXLeop5jjxboAgAAAJ/A=
Date: Tue, 23 Apr 2013 13:02:38 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D4B4A00@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1366691726-9023-1-git-send-email-Varun.Sethi@freescale.com>
 <20130423125827.GD2589@8bytes.org>
In-Reply-To: <20130423125827.GD2589@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.154]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of Joerg Roedel
> Sent: Tuesday, April 23, 2013 6:32 PM
> To: Sethi Varun-B16395
> Cc: galak@kernel.crashing.org; benh@kernel.crashing.org; Yoder Stuart-
> B08248; linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org;
> Wood Scott-B07421; linuxppc-dev@lists.ozlabs.org
> Subject: Re: [PATCH 1/3 v2] iommu: Move swap_pci_ref function to pci.h.
> 
> On Tue, Apr 23, 2013 at 10:05:24AM +0530, Varun Sethi wrote:
> > +#ifndef __PCI_H
> > +#define __PCI_H
> 
> Using __PCI_H is not a wise choice, it has certainly a high risk of a
> collision. Anyway, I changed it to __IOMMU_PCI_H and applied the patch.
> 
> 
> 	Joerg
> 
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu


