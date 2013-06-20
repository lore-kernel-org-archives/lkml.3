Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab3FTEQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 00:16:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38921 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab3FTEQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 00:16:58 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: RE: [PATCH v3 1/4] MFD: Palmas: Check if irq is valid
Thread-Topic: [PATCH v3 1/4] MFD: Palmas: Check if irq is valid
Thread-Index: AQHObLIGtU4PkvUD5U+jS6p5a9n8zZk8uJYAgAFH1QA=
Date: Thu, 20 Jun 2013 04:16:32 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229ECBBF@DBDE04.ent.ti.com>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
 <1371621470-22279-2-git-send-email-j-keerthy@ti.com>
 <20130619164254.GA1403@sirena.org.uk>
In-Reply-To: <20130619164254.GA1403@sirena.org.uk>
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
> Sent: Wednesday, June 19, 2013 10:13 PM
> To: J, KEERTHY
> Cc: linux-omap@vger.kernel.org; ldewangan@nvidia.com;
> sameo@linux.intel.com; grant.likely@secretlab.ca; swarren@nvidia.com;
> linux-kernel@vger.kernel.org; linux-doc@vger.kernel.org; devicetree-
> discuss@lists.ozlabs.org; gg@slimlogic.co.uk
> Subject: Re: [PATCH v3 1/4] MFD: Palmas: Check if irq is valid
> 
> On Wed, Jun 19, 2013 at 11:27:47AM +0530, Keerthy wrote:
> > From: J Keerthy <j-keerthy@ti.com>
> >
> > Check if irq value obtained is valid. If it is not valid then skip
> the
> > irq request step and go ahead with the probe.
> >
> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> 
> Reviewed-by: Mark Brown <broonie@linaro.org>

Thanks Mark.
