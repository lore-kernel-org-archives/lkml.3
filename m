Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab3CQPt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 11:49:29 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:5738
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756419Ab3CQPtZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 11:49:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH 5/5 v9] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Thread-Topic: [PATCH 5/5 v9] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Thread-Index: AQHOIPGuJ0i4ZHPe+UWlsK/sgbiUbpiqC9uw
Date: Sun, 17 Mar 2013 15:49:20 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D40ABC2@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1363200580-11623-1-git-send-email-Varun.Sethi@freescale.com>
 <0080B56D-8417-41B9-8341-665457D04DE6@kernel.crashing.org>
 <DF9A711B-63AF-411C-84E4-0C9F61A2EB21@kernel.crashing.org>
In-Reply-To: <DF9A711B-63AF-411C-84E4-0C9F61A2EB21@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.193]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org]
> Sent: Friday, March 15, 2013 1:53 AM
> To: Sethi Varun-B16395
> Cc: joro@8bytes.org; linux-kernel@vger.kernel.org; Yoder Stuart-B08248;
> iommu@lists.linux-foundation.org; Wood Scott-B07421; linuxppc-
> dev@lists.ozlabs.org
> Subject: Re: [PATCH 5/5 v9] iommu/fsl: Freescale PAMU driver and iommu
> implementation.
> 
> 
> On Mar 14, 2013, at 3:20 PM, Kumar Gala wrote:
> 
> >
> > On Mar 13, 2013, at 1:49 PM, Varun Sethi wrote:
> >
> >> +/*
> >> + * Table of SVRs and the corresponding PORT_ID values.
> >> + *
> >> + * All future CoreNet-enabled SOCs will have this erratum fixed, so
> >> +this table
> >> + * should never need to be updated.  SVRs are guaranteed to be
> >> +unique, so
> >> + * there is no worry that a future SOC will inadvertently have one
> >> +of these
> >> + * values.
> >> + */
> >
> > Maybe add to the comment about what port_id represents
> 
> also, add reference to the erratum #/id/name
> 
[Sethi Varun-B16395] Ok.

-Varun

