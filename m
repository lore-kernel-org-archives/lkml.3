Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab3CNVaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:30:00 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:46697
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752991Ab3CNV37 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:29:59 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Mar 2013 17:29:59 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Yoder Stuart-B08248 <B08248@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>,
        Sethi Varun-B16395 <B16395@freescale.com>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: RE: [PATCH 5/5 v9] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Thread-Topic: [PATCH 5/5 v9] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Thread-Index: AQHOIPF/4Mvb0DPAr0qXmtpkEQeBHZilr5TQ
Date: Thu, 14 Mar 2013 21:14:52 +0000
Message-ID: <9F6FE96B71CF29479FF1CDC8046E1503586936@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1363200580-11623-1-git-send-email-Varun.Sethi@freescale.com>
 <0080B56D-8417-41B9-8341-665457D04DE6@kernel.crashing.org>
In-Reply-To: <0080B56D-8417-41B9-8341-665457D04DE6@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.82.121.95]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org]
> Sent: Thursday, March 14, 2013 3:20 PM
> To: Sethi Varun-B16395
> Cc: joro@8bytes.org; iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; benh@kernel.crashing.org; Wood Scott-B07421; Yoder Stuart-B08248
> Subject: Re: [PATCH 5/5 v9] iommu/fsl: Freescale PAMU driver and iommu implementation.
> 
> 
> On Mar 13, 2013, at 1:49 PM, Varun Sethi wrote:
> 
> > +/*
> > + * Table of SVRs and the corresponding PORT_ID values.
> > + *
> > + * All future CoreNet-enabled SOCs will have this erratum fixed, so this table
> > + * should never need to be updated.  SVRs are guaranteed to be unique, so
> > + * there is no worry that a future SOC will inadvertently have one of these
> > + * values.
> > + */
> 
> Maybe add to the comment about what port_id represents

When you update the comment, I would also suggest identifying the specific
errata here (A-004510) so that it's easy to reference back to the specific
issue this code is fixing.

Stuart

