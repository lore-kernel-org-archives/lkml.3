Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab3GBJnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:43:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37227 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab3GBJm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:42:59 -0400
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
Thread-Index: AQHObaYtxXLB3GJS60SmpjiKShwczJlE2MoggAQqidCACDI3cA==
Date: Tue, 2 Jul 2013 09:42:41 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229F80C6@DBDE04.ent.ti.com>
References: <1371726289-10042-1-git-send-email-j-keerthy@ti.com>
 <DC88CAD03C0052499C1907B327FC63229EF495@DBDE04.ent.ti.com> 
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


Hello Grant,

> -----Original Message-----
> From: J, KEERTHY
> Sent: Thursday, June 27, 2013 10:03 AM
> To: grant.likely@secretlab.ca
> Cc: broonie@kernel.org; ldewangan@nvidia.com; sameo@linux.intel.com;
> swarren@nvidia.com; linux-kernel@vger.kernel.org; linux-
> doc@vger.kernel.org; devicetree-discuss@lists.ozlabs.org;
> gg@slimlogic.co.uk; linux-omap@vger.kernel.org
> Subject: RE: [PATCH 1/4] MFD: Add TPS659038 documentation under Palmas
> 
> Hi Grant,
> 
> 
> > -----Original Message-----
> > From: J, KEERTHY
> > Sent: Monday, June 24, 2013 6:26 PM
> > To: grant.likely@secretlab.ca
> > Cc: broonie@kernel.org; ldewangan@nvidia.com; sameo@linux.intel.com;
> > swarren@nvidia.com; linux-kernel@vger.kernel.org; linux-
> > doc@vger.kernel.org; devicetree-discuss@lists.ozlabs.org;
> > gg@slimlogic.co.uk; J, KEERTHY; linux-omap@vger.kernel.org
> > Subject: RE: [PATCH 1/4] MFD: Add TPS659038 documentation under
> Palmas
> >
> > Hello Grant,
> >
> > > -----Original Message-----
> > > From: J, KEERTHY
> > > Sent: Thursday, June 20, 2013 4:35 PM
> > > To: linux-omap@vger.kernel.org; grant.likely@secretlab.ca
> > > Cc: broonie@kernel.org; J, KEERTHY; ldewangan@nvidia.com;
> > > sameo@linux.intel.com; swarren@nvidia.com; linux-
> > > kernel@vger.kernel.org; linux-doc@vger.kernel.org; devicetree-
> > > discuss@lists.ozlabs.org; gg@slimlogic.co.uk
> > > Subject: [PATCH 1/4] MFD: Add TPS659038 documentation under Palmas
> > >
> > > Add TPS659038 documentation under Palmas.
> > >
> >
> > Could you pull this Please?
> 
> A gentle ping on this.
>

A gentle ping on this. Could you pull this one?
 
> >
> > > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > > Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> > > ---
> > >  Documentation/devicetree/bindings/mfd/palmas.txt |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt
> > > b/Documentation/devicetree/bindings/mfd/palmas.txt
> > > index 7bcd59c..89cb773 100644
> > > --- a/Documentation/devicetree/bindings/mfd/palmas.txt
> > > +++ b/Documentation/devicetree/bindings/mfd/palmas.txt
> > > @@ -5,6 +5,7 @@ twl6035 (palmas)
> > >  twl6037 (palmas)
> > >  tps65913 (palmas)
> > >  tps65914 (palmas)
> > > +tps659038
> > >
> > >  Required properties:
> > >  - compatible : Should be from the list @@ -14,6 +15,7 @@ Required
> > > properties:
> > >    ti,tps65913
> > >    ti,tps65914
> > >    ti,tps80036
> > > +  ti,tps659038
> > >  and also the generic series names
> > >    ti,palmas
> > >  - interrupt-controller : palmas has its own internal IRQs
> > > --
> > > 1.7.5.4
> >
> > Regards,
> > Keerthy
> 
> Regards,
> Keerthy

Regards,
Keerthy
