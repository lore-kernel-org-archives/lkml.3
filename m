Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705Ab3BTJlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:41:13 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:28725
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934273Ab3BTJlK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:41:10 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(z551bizbb2dI98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Craciun Diana Madalina-STFD002 <STFD002@freescale.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>
Subject: RE: [PATCH 6/6 v8] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Topic: [PATCH 6/6 v8] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Index: AQHODdfbgGU1NqcYVkONwLkDSaaXgpiBWIyAgAEoeEA=
Date: Wed, 20 Feb 2013 09:41:05 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D3AC29D@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
 <1361191939-21260-7-git-send-email-Varun.Sethi@freescale.com>
 <5123A169.9060100@freescale.com>
In-Reply-To: <5123A169.9060100@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Craciun Diana Madalina-STFD002
> Sent: Tuesday, February 19, 2013 9:30 PM
> To: Sethi Varun-B16395
> Cc: iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org;
> linux-kernel@vger.kernel.org; Wood Scott-B07421; joro@8bytes.org; Yoder
> Stuart-B08248
> Subject: Re: [PATCH 6/6 v8] iommu/fsl: Freescale PAMU driver and IOMMU
> API implementation.
> 
> On 02/18/2013 02:52 PM, Varun Sethi wrote:
> > +/**
> > + * pamu_get_ppaace() - Return the primary PACCE
> > + * @liodn: liodn PAACT index for desired PAACE
> > + *
> > + * Returns the ppace pointer upon success else return
> > + * null.
> > + */
> > +static struct paace *pamu_get_ppaace(int liodn) {
> > +	if (!ppaact || liodn > PAACE_NUMBER_ENTRIES) {
> 
> Shouldn't be "liodn >= PAACE_NUMBER_ENTRIES" ?
Yes, will fix this.

-Varun

