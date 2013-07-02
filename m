Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab3GBJmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:42:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37190 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab3GBJmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:42:21 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: "J, KEERTHY" <j-keerthy@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
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
Subject: RE: [PATCH 3/4] regulators: Add TPS659038 documentation under Palmas
Thread-Topic: [PATCH 3/4] regulators: Add TPS659038 documentation under
 Palmas
Thread-Index: AQHObaZOnplXeq3e6k651zZU6Eld4JlJA7vQgAgxlmA=
Date: Tue, 2 Jul 2013 09:41:55 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229F80B4@DBDE04.ent.ti.com>
References: <1371726344-10115-1-git-send-email-j-keerthy@ti.com> 
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
> Sent: Thursday, June 27, 2013 10:05 AM
> To: grant.likely@secretlab.ca
> Cc: broonie@kernel.org; ldewangan@nvidia.com; sameo@linux.intel.com;
> swarren@nvidia.com; linux-kernel@vger.kernel.org; linux-
> doc@vger.kernel.org; devicetree-discuss@lists.ozlabs.org;
> gg@slimlogic.co.uk; linux-omap@vger.kernel.org
> Subject: RE: [PATCH 3/4] regulators: Add TPS659038 documentation under
> Palmas
> 
> Hello Grant,
> 
> > -----Original Message-----
> > From: J, KEERTHY
> > Sent: Thursday, June 20, 2013 4:36 PM
> > To: linux-omap@vger.kernel.org; grant.likely@secretlab.ca
> > Cc: broonie@kernel.org; J, KEERTHY; ldewangan@nvidia.com;
> > sameo@linux.intel.com; swarren@nvidia.com; linux-
> > kernel@vger.kernel.org; linux-doc@vger.kernel.org; devicetree-
> > discuss@lists.ozlabs.org; gg@slimlogic.co.uk
> > Subject: [PATCH 3/4] regulators: Add TPS659038 documentation under
> > Palmas
> >
> > Add TPS659038 documentation under Palmas.
> >
> 
> Could you please pull this one?
> 

A gentle ping on this. Could you pull this one.

> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > Acked-by: Mark Brown <broonie@linaro.org>
> > ---
> >  .../devicetree/bindings/regulator/palmas-pmic.txt  |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/regulator/palmas-
> > pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-
> pmic.txt
> > index d5a3086..5115cd7 100644
> > --- a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> > +++ b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> > @@ -7,6 +7,7 @@ Required properties:
> >    ti,twl6037-pmic
> >    ti,tps65913-pmic
> >    ti,tps65914-pmic
> > +  ti,tps659038-pmic
> >  and also the generic series names
> >    ti,palmas-pmic
> >  - interrupt-parent : The parent interrupt controller which is
> palmas.
> > --
> > 1.7.5.4
> 
> Regards,
> Keerthy

Regards,
Keerthy
