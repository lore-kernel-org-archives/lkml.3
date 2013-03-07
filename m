Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab3CGJO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:14:28 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:39321 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754404Ab3CGJOZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:14:25 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joro@8bytes.org>
CC: Stuart Yoder <b08248@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: RE: [PATCH 2/6] powerpc/fsl_pci: Store the platform device
 information corresponding to the pci controller.
Thread-Topic: [PATCH 2/6] powerpc/fsl_pci: Store the platform device
 information corresponding to the pci controller.
Thread-Index: AQHODdfJlEhE0nyIf0aqdKEpYTrUTpiLT0kAgABlsACAAd5YgIAAAghwgAHkLgCACpAcsA==
Date: Thu, 7 Mar 2013 09:14:21 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D3E74C7@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
 <1361191939-21260-3-git-send-email-Varun.Sethi@freescale.com>
 <CALRxmdDc9TuxH7HgAF3_iLgatoaOUML6fUt8SU+sxHyz6ZVjfw@mail.gmail.com>
 <C5ECD7A89D1DC44195F34B25E172658D3BD338@039-SN2MPN1-013.039d.mgd.msft.net>
 <20130227104505.GE26252@8bytes.org>
 <C5ECD7A89D1DC44195F34B25E172658D3C24A9@039-SN2MPN1-013.039d.mgd.msft.net>
 <D109CC7C-09D2-41E6-82BF-376692C390CA@kernel.crashing.org>
In-Reply-To: <D109CC7C-09D2-41E6-82BF-376692C390CA@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.133.65]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,
I have to post the next version of my patchset, should I base it on top of 3.9-rc1?
By when would you move the iommu git tree to 3.9-rc1?

Regards
Varun

> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org]
> Sent: Thursday, February 28, 2013 9:15 PM
> To: Sethi Varun-B16395
> Cc: Joerg Roedel; Stuart Yoder; iommu@lists.linux-foundation.org;
> linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Wood Scott-
> B07421; Yoder Stuart-B08248
> Subject: Re: [PATCH 2/6] powerpc/fsl_pci: Store the platform device
> information corresponding to the pci controller.
> 
> 
> On Feb 27, 2013, at 4:56 AM, Sethi Varun-B16395 wrote:
> 
> > This patch is present in the "next branch" of linux ppc tree maintained
> by Kumar Gala.
> > Following is the commit id:
> > 52c5affc545053d37c0b05224bbf70f5336caa20
> >
> > I am not sure if this would be part of 3.9-rc1.
> >
> > Regards
> > varun
> 
> This is now in Linus's tree so will be in 3.9-rc1
> 
> - k
> 


