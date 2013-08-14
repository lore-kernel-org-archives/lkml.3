Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab3HNQo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:44:27 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:8748 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932701Ab3HNQo0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:44:26 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: RE: [PATCH 1/3] powerpc: Add iommu domain pointer to device archdata
Thread-Topic: [PATCH 1/3] powerpc: Add iommu domain pointer to device
 archdata
Thread-Index: AQHOgRi4nTlTf9YUUkWja9eSx6cVn5mUpIuAgAABx+CAAGpwAIAACAwA
Date: Wed, 14 Aug 2013 16:44:18 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D0A42F5C6@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1373863857-27239-1-git-send-email-Varun.Sethi@freescale.com>
 <20130814094802.GC4491@8bytes.org>
 <C5ECD7A89D1DC44195F34B25E172658D0A42CDB5@039-SN2MPN1-013.039d.mgd.msft.net>
 <20130814161522.GP28811@8bytes.org>
In-Reply-To: <20130814161522.GP28811@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Joerg.

> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Wednesday, August 14, 2013 9:45 PM
> To: Sethi Varun-B16395
> Cc: iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org;
> linux-kernel@vger.kernel.org; benh@kernel.crashing.org;
> galak@kernel.crashing.org; alex.williamson@redhat.com; Yoder Stuart-
> B08248; Wood Scott-B07421
> Subject: Re: [PATCH 1/3] powerpc: Add iommu domain pointer to device
> archdata
> 
> On Wed, Aug 14, 2013 at 09:56:11AM +0000, Sethi Varun-B16395 wrote:
> > Please find the .config file attached with this mail.
> 
> Fantastic, thanks. The build works fine, I'll include the driver into my
> next-branch. I also have two minor clean-up patches on-top, just if you
> where wondering.
> 
> 
> 	Joerg
> 
> 


