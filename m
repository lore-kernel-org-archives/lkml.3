Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab3FXQWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:22:02 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46382 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab3FXQV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:21:59 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: RE: [PATCH 2/4] MFD: Palmas: Add TPS659038 PMIC support
Thread-Topic: [PATCH 2/4] MFD: Palmas: Add TPS659038 PMIC support
Thread-Index: AQHObaY940mmlA2QH0SGEMxdlPp4eZlEPqYAgADTscA=
Date: Mon, 24 Jun 2013 16:21:34 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229EF57C@DBDE04.ent.ti.com>
References: <1371726316-10078-1-git-send-email-j-keerthy@ti.com>
 <20130624114322.GB30838@zurbaran>
In-Reply-To: <20130624114322.GB30838@zurbaran>
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
> From: Samuel Ortiz [mailto:sameo@linux.intel.com]
> Sent: Monday, June 24, 2013 5:13 PM
> To: J, KEERTHY
> Cc: linux-omap@vger.kernel.org; broonie@kernel.org;
> ldewangan@nvidia.com; grant.likely@secretlab.ca; swarren@nvidia.com;
> linux-kernel@vger.kernel.org; linux-doc@vger.kernel.org; devicetree-
> discuss@lists.ozlabs.org; gg@slimlogic.co.uk
> Subject: Re: [PATCH 2/4] MFD: Palmas: Add TPS659038 PMIC support
> 
> Hi,
> 
> On Thu, Jun 20, 2013 at 04:35:16PM +0530, J Keerthy wrote:
> > The Patch adds TPS659038 PMIC support in the palmas mfd driver.
> > The TPS659038 has almost the same registers as of the earlier
> > supported variants of PALMAS family such as the TWL6035.
> >
> > The critical differences between TPS659038 and TWL6035 being:
> >
> > 1) TPS659038 has nothing related to battery charging and back up
> battery stuff.
> > 2) TPS659038 does not have does not have SMPS10(Boost) step up
> convertor.
> > 3) TPS659038 does not have Battery detection and anything related to
> battery.
> > 4) SD card detection, Battery presence detection, Vibrator, USB OTG
> are missing
> >    when compared to TWL6035.
> >
> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> > ---
> >  drivers/mfd/palmas.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> Applied, thanks.

Thanks Samuel.

> 
> Cheers,
> Samuel.
> 
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
