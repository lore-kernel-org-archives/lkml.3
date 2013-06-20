Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030263Ab3FTOa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:30:27 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:23983
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878Ab3FTOa0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:30:26 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: "joro@8bytes.org" <joro@8bytes.org>
CC: Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: RE: [PATCH 2/5 v11] powerpc: Add iommu domain pointer to device
 archdata
Thread-Topic: [PATCH 2/5 v11] powerpc: Add iommu domain pointer to device
 archdata
Thread-Index: AQHOK+8khWuiv7ZxxUGiwKSUgC0KZZjRaX6AgG3DdUA=
Date: Thu, 20 Jun 2013 14:29:30 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D5CB5D4@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
 <1364500442-20927-3-git-send-email-Varun.Sethi@freescale.com>
 <AC9BAE34-A9CB-4A24-A357-0AA7734CE443@kernel.crashing.org>
In-Reply-To: <AC9BAE34-A9CB-4A24-A357-0AA7734CE443@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,
My PAMU driver patches depend on this patch which was Ack by Kumar. Should I resubmit this patch as well?

Regards
Varun

> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org]
> Sent: Thursday, April 11, 2013 11:46 PM
> To: Sethi Varun-B16395
> Cc: joro@8bytes.org; Yoder Stuart-B08248; Wood Scott-B07421;
> iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; benh@kernel.crashing.org
> Subject: Re: [PATCH 2/5 v11] powerpc: Add iommu domain pointer to device
> archdata
> 
> 
> On Mar 28, 2013, at 2:53 PM, Varun Sethi wrote:
> 
> > Add an iommu domain pointer to device (powerpc) archdata.  Devices are
> > attached to iommu domains and this pointer provides a mechanism to
> > correlate between a device and the associated iommu domain.  This
> > field is set when a device is attached to a domain.
> >
> > Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> > ---
> > - no change in v11.
> > - no change in v10.
> > - Added CONFIG_IOMMU_API in v9.
> > arch/powerpc/include/asm/device.h |    6 ++++++
> > 1 files changed, 6 insertions(+), 0 deletions(-)
> 
> Acked-by: Kumar Gala <galak@kernel.crashing.org>
> 
> - k


