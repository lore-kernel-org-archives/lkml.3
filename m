Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3DWP0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:26:39 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:54099
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756259Ab3DWP0h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:26:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Yoder Stuart-B08248 <B08248@freescale.com>
To: Joerg Roedel <joro@8bytes.org>, Sethi Varun-B16395 <B16395@freescale.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: RE: [PATCH 2/3 v14] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Thread-Topic: [PATCH 2/3 v14] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Thread-Index: AQHOP90ueMZs0xyX9kyMT5cttYuM/pjjz/0AgAAdNxA=
Date: Tue, 23 Apr 2013 15:26:25 +0000
Message-ID: <9F6FE96B71CF29479FF1CDC8046E15035BE00E@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1366691726-9023-1-git-send-email-Varun.Sethi@freescale.com>
 <1366691726-9023-2-git-send-email-Varun.Sethi@freescale.com>
 <20130423133837.GG17148@8bytes.org>
In-Reply-To: <20130423133837.GG17148@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.185.244]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Tuesday, April 23, 2013 8:39 AM
> To: Sethi Varun-B16395
> Cc: iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> galak@kernel.crashing.org; benh@kernel.crashing.org; Yoder Stuart-B08248; Wood Scott-B07421
> Subject: Re: [PATCH 2/3 v14] iommu/fsl: Add additional iommu attributes required by the PAMU driver.
> 
> On Tue, Apr 23, 2013 at 10:05:25AM +0530, Varun Sethi wrote:
> > Added the following domain attributes for the FSL PAMU driver:
> > 1. Added new iommu stash attribute, which allows setting of the
> >    LIODN specific stash id parameter through IOMMU API.
> > 2. Added an attribute for enabling/disabling DMA to a particular
> >    memory window.
> > 3. Added domain attribute to check for PAMUV1 specific constraints.
> >
> > Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> > ---
> > v14 changes:
> > - Add FSL prefix to PAMU attributes.
> > v13 changes:
> > - created a new file include/linux/fsl_pamu_stash.h for stash
> > attributes.
> > v12 changes:
> > - Moved PAMU specifc stash ids and structures to PAMU header file.
> > - no change in v11.
> > - no change in v10.
> >  include/linux/fsl_pamu_stash.h |   39 +++++++++++++++++++++++++++++++++++++++
> 
> Isn't asm/ for your architecture a better place for that header?

The PAMU isn't strictly tied to Power architecture, although
that is where it is implemented now.  It could be implemented
on ARM for example.

Stuart


