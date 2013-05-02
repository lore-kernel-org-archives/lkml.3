Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360Ab3EBN0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:26:33 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:17318
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758008Ab3EBN0b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:26:31 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fhbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: "joro@8bytes.org" <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: RE: [PATCH 1/2 v15] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Thread-Topic: [PATCH 1/2 v15] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Thread-Index: AQHOQOEVXyYrk6lRr0mRMnByFKC5lpjvCPDAgAKxhoCAACspwA==
Date: Thu, 2 May 2013 13:26:05 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D4D308F@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1366803351-17429-1-git-send-email-Varun.Sethi@freescale.com>
 <C5ECD7A89D1DC44195F34B25E172658D4CBC45@039-SN2MPN1-011.039d.mgd.msft.net>
 <20130502101629.GA24440@8bytes.org>
In-Reply-To: <20130502101629.GA24440@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: joro@8bytes.org [mailto:joro@8bytes.org]
> Sent: Thursday, May 02, 2013 3:46 PM
> To: Sethi Varun-B16395
> Cc: iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org;
> linux-kernel@vger.kernel.org; galak@kernel.crashing.org;
> benh@kernel.crashing.org; Yoder Stuart-B08248; Wood Scott-B07421
> Subject: Re: [PATCH 1/2 v15] iommu/fsl: Add additional iommu attributes
> required by the PAMU driver.
> 
> On Tue, Apr 30, 2013 at 05:09:32PM +0000, Sethi Varun-B16395 wrote:
> > Would you take this patchset for 3.10 merge?
> 
> Not this time. The final patch came in very late and is pretty big too.
> For code of that size I would like to have a few weeks more testing in
> next and probably also a non-Freescale Reviewed-by.
[Sethi Varun-B16395] I would request you and Alex Williamson to review the patch and provide a Reviewed-by.

-Varun

