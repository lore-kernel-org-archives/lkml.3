Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab3FTEUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 00:20:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43227 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab3FTEUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 00:20:00 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Mark Brown <broonie@kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: RE: [PATCH v3 4/4] regulator: Palmas: Add TPS659038 support
Thread-Topic: [PATCH v3 4/4] regulator: Palmas: Add TPS659038 support
Thread-Index: AQHObLISzsmzmXGbpEuLkOU7SNcdMZk8uHIAgAFIFvA=
Date: Thu, 20 Jun 2013 04:19:37 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229ECBD0@DBDE04.ent.ti.com>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
 <1371621470-22279-5-git-send-email-j-keerthy@ti.com>
 <20130619164224.GZ1403@sirena.org.uk>
In-Reply-To: <20130619164224.GZ1403@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Wednesday, June 19, 2013 10:12 PM
> To: J, KEERTHY
> Cc: linux-omap@vger.kernel.org; ldewangan@nvidia.com;
> sameo@linux.intel.com; grant.likely@secretlab.ca; swarren@nvidia.com;
> linux-kernel@vger.kernel.org; linux-doc@vger.kernel.org; devicetree-
> discuss@lists.ozlabs.org; gg@slimlogic.co.uk
> Subject: Re: [PATCH v3 4/4] regulator: Palmas: Add TPS659038 support
> 
> On Wed, Jun 19, 2013 at 11:27:50AM +0530, Keerthy wrote:
> > From: J Keerthy <j-keerthy@ti.com>
> >
> > Add TPS659038 support.
> >
> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> 
> This doesn't apply against my current tree as the PMIC bindings
> document isn't in mainline yet.

It was pulled by Grant.

> 
> Acked-by: Mark Brown <broonie@linaro.org>
> 
> assuming there's a tree where that does exist.

Thanks. I will check if Grant can pull this.
