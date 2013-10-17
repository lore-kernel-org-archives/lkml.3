Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab3JQNtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:49:17 -0400
Received: from [216.32.180.188] ([216.32.180.188]:16108 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754624Ab3JQNtQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:49:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Sethi Varun-B16395 <B16395@freescale.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Bhushan Bharat-R65777 <R65777@freescale.com>
Subject: RE: [PATCH 0/3 v2] iommu/fsl: PAMU driver fixes.
Thread-Topic: [PATCH 0/3 v2] iommu/fsl: PAMU driver fixes.
Thread-Index: AQHOymPo+73p9hhU20CjtA/9SyqCl5n46eng
Date: Thu, 17 Oct 2013 13:47:38 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D0A5456C2@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1381922582-28724-1-git-send-email-Varun.Sethi@freescale.com>
In-Reply-To: <1381922582-28724-1-git-send-email-Varun.Sethi@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.136]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,
Please consider these patches for 3.12.

Regards
Varun

> -----Original Message-----
> From: Sethi Varun-B16395
> Sent: Wednesday, October 16, 2013 4:53 PM
> To: joro@8bytes.org; iommu@lists.linux-foundation.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Yoder Stuart-B08248;
> Wood Scott-B07421; alex.williamson@redhat.com; Bhushan Bharat-R65777
> Cc: Sethi Varun-B16395
> Subject: [PATCH 0/3 v2] iommu/fsl: PAMU driver fixes.
> 
> The first patch fixes a build failure, when we try to build for a
> Freescale platform without PCI support.
> 
> The second patch enables a default DMA window for the device, once it's
> detached from a domain. In case of vfio, once device is detached from a
> guest it can be again used by the host.
> 
> The last patch adds the maintainer entry for the Freescale PAMU driver.
> 
> Varun Sethi (3):
>   iommu/fsl: Factor out PCI specific code.
>   iommu/fsl: Enable default DMA window for PCIe devices once detached
>   Add maintainers entry for the Freescale PAMU driver.
> 
>  MAINTAINERS                     |    7 ++
>  drivers/iommu/fsl_pamu.c        |   43 ++++++++++---
>  drivers/iommu/fsl_pamu.h        |    1 +
>  drivers/iommu/fsl_pamu_domain.c |  134 +++++++++++++++++++++++++--------
> ------
>  4 files changed, 128 insertions(+), 57 deletions(-)
> 
> --
> 1.7.9.5


