Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab3DORNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:13:12 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:36224
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755735Ab3DORNI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:13:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ahbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joro@8bytes.org>
CC: Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Subject: RE: [PATCH 1/3] iommu: Move swap_pci_ref function to pci.h.
Thread-Topic: [PATCH 1/3] iommu: Move swap_pci_ref function to pci.h.
Thread-Index: AQHOOUUdmvpHLN9SKk2XFrKoKk+1P5jXYN2AgAAla7A=
Date: Mon, 15 Apr 2013 17:13:01 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D486DF2@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1365966722-1804-1-git-send-email-Varun.Sethi@freescale.com>
 <20130415145834.GR6858@8bytes.org>
In-Reply-To: <20130415145834.GR6858@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [69.38.217.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fine, I will move it to iommu.h.

-Varun

> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Monday, April 15, 2013 8:29 PM
> To: Sethi Varun-B16395
> Cc: Yoder Stuart-B08248; Wood Scott-B07421; iommu@lists.linux-
> foundation.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; galak@kernel.crashing.org;
> benh@kernel.crashing.org; bhelgaas@google.com
> Subject: Re: [PATCH 1/3] iommu: Move swap_pci_ref function to pci.h.
> 
> On Mon, Apr 15, 2013 at 12:42:00AM +0530, Varun Sethi wrote:
> > swap_pci_ref function is used by the IOMMU API code for swapping pci
> > device pointers, while determining the iommu group for the device.
> > Currently this function was being implemented for different IOMMU
> drivers.
> > This patch moves the function to pci.h so that the implementation can
> > be shared across various IOMMU drivers.
> 
> The function is only used in IOMMU code, so I think its fine to keep it
> there (unless Bjorn disagrees and wants it in PCI code).
> 
> 
> 	Joerg
> 
> 


