Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761057Ab3DBRvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:51:10 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:56493
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758307Ab3DBRvI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:51:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z551biz98dI9371I542I1432Id799hzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ahbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joro@8bytes.org>
CC: Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Bhushan Bharat-R65777 <R65777@freescale.com>
Subject: RE: [PATCH 0/5 v11] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Topic: [PATCH 0/5 v11] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Index: AQHOK+8bPbDn+BJThEe8QO8hqmo88pjDJN8AgAAVX7A=
Date: Tue, 2 Apr 2013 17:50:50 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D44E415@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
 <20130402162310.GJ15687@8bytes.org>
In-Reply-To: <20130402162310.GJ15687@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.64.44.154]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Tuesday, April 02, 2013 9:53 PM
> To: Sethi Varun-B16395
> Cc: Yoder Stuart-B08248; Wood Scott-B07421; iommu@lists.linux-
> foundation.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; galak@kernel.crashing.org;
> benh@kernel.crashing.org
> Subject: Re: [PATCH 0/5 v11] iommu/fsl: Freescale PAMU driver and IOMMU
> API implementation.
> 
> On Fri, Mar 29, 2013 at 01:23:57AM +0530, Varun Sethi wrote:
> > This patchset provides the Freescale PAMU (Peripheral Access
> > Management Unit) driver and the corresponding IOMMU API
> > implementation. PAMU is the IOMMU present on Freescale QorIQ
> > platforms. PAMU can authorize memory access, remap the memory address,
> and remap the I/O transaction type.
> >
> > This set consists of the following patches:
> > 1.  Make iova dma_addr_t in the iommu_iova_to_phys API.
> > 2. Addition of new field in the device (powerpc) archdata structure for
> storing iommu domain information
> >    pointer.
> > 3. Add window permission flags in the iommu_domain_window_enable API.
> > 4. Add domain attributes for FSL PAMU driver.
> > 5. PAMU driver and IOMMU API implementation.
> 
> Okay, I am about to apply patches 1 and 3 to a new ppc/pamu branch in my
> tree.
> 
> As a general question, how did you test the IOMMU driver and what will
> you do in the future to avoid regressions?
> 
I use a kernel module for testing the iommu_api support. The module allows for dynamic creation and deletion of iommu domains for the devices in the device tree. Also, the vfio support (under development) for Freescale SOCs with APMU hardware would depend on the PAMU driver.

-Varun


