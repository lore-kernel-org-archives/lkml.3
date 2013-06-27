Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab3F0EdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 00:33:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34881 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab3F0EdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 00:33:11 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH 1/4] MFD: Add TPS659038 documentation under Palmas
Thread-Topic: [PATCH 1/4] MFD: Add TPS659038 documentation under Palmas
Thread-Index: AQHObaYtxXLB3GJS60SmpjiKShwczJlE2MoggAQqidA=
Date: Thu, 27 Jun 2013 04:32:50 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229F01F8@DBDE04.ent.ti.com>
References: <1371726289-10042-1-git-send-email-j-keerthy@ti.com>
 <DC88CAD03C0052499C1907B327FC63229EF495@DBDE04.ent.ti.com>
In-Reply-To: <DC88CAD03C0052499C1907B327FC63229EF495@DBDE04.ent.ti.com>
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

Hi Grant,


> -----Original Message-----
> From: J, KEERTHY
> Sent: Monday, June 24, 2013 6:26 PM
> To: grant.likely@secretlab.ca
> Cc: broonie@kernel.org; ldewangan@nvidia.com; sameo@linux.intel.com;
> swarren@nvidia.com; linux-kernel@vger.kernel.org; linux-
> doc@vger.kernel.org; devicetree-discuss@lists.ozlabs.org;
> gg@slimlogic.co.uk; J, KEERTHY; linux-omap@vger.kernel.org
> Subject: RE: [PATCH 1/4] MFD: Add TPS659038 documentation under Palmas
> 
> Hello Grant,
> 
> > -----Original Message-----
> > From: J, KEERTHY
> > Sent: Thursday, June 20, 2013 4:35 PM
> > To: linux-omap@vger.kernel.org; grant.likely@secretlab.ca
> > Cc: broonie@kernel.org; J, KEERTHY; ldewangan@nvidia.com;
> > sameo@linux.intel.com; swarren@nvidia.com; linux-
> > kernel@vger.kernel.org; linux-doc@vger.kernel.org; devicetree-
> > discuss@lists.ozlabs.org; gg@slimlogic.co.uk
> > Subject: [PATCH 1/4] MFD: Add TPS659038 documentation under Palmas
> >
> > Add TPS659038 documentation under Palmas.
> >
> 
> Could you pull this Please?

A gentle ping on this.

> 
> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> > ---
> >  Documentation/devicetree/bindings/mfd/palmas.txt |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt
> > b/Documentation/devicetree/bindings/mfd/palmas.txt
> > index 7bcd59c..89cb773 100644
> > --- a/Documentation/devicetree/bindings/mfd/palmas.txt
> > +++ b/Documentation/devicetree/bindings/mfd/palmas.txt
> > @@ -5,6 +5,7 @@ twl6035 (palmas)
> >  twl6037 (palmas)
> >  tps65913 (palmas)
> >  tps65914 (palmas)
> > +tps659038
> >
> >  Required properties:
> >  - compatible : Should be from the list @@ -14,6 +15,7 @@ Required
> > properties:
> >    ti,tps65913
> >    ti,tps65914
> >    ti,tps80036
> > +  ti,tps659038
> >  and also the generic series names
> >    ti,palmas
> >  - interrupt-controller : palmas has its own internal IRQs
> > --
> > 1.7.5.4
> 
> Regards,
> Keerthy

Regards,
Keerthy
