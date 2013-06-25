Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab3FYKVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:21:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45236 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab3FYKVu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:21:50 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH 4/4] regulator: Palmas: Add TPS659038 support
Thread-Topic: [PATCH 4/4] regulator: Palmas: Add TPS659038 support
Thread-Index: AQHObaXOcBDbRKATXEyyLvcmOHJ1Xpk/4kGAgAZdviA=
Date: Tue, 25 Jun 2013 10:21:26 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229EF8A7@DBDE04.ent.ti.com>
References: <1371726135-9891-1-git-send-email-j-keerthy@ti.com> 
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

Hi Samuel,

> -----Original Message-----
> From: J, KEERTHY
> Sent: Friday, June 21, 2013 2:38 PM
> To: sameo@linux.intel.com
> Cc: broonie@kernel.org; ldewangan@nvidia.com;
> grant.likely@secretlab.ca; swarren@nvidia.com; linux-
> kernel@vger.kernel.org; linux-doc@vger.kernel.org; gg@slimlogic.co.uk;
> linux-omap@vger.kernel.org
> Subject: RE: [PATCH 4/4] regulator: Palmas: Add TPS659038 support
> 
> Hi Samuel,
> 
> > -----Original Message-----
> > From: J, KEERTHY
> > Sent: Thursday, June 20, 2013 4:32 PM
> > To: linux-omap@vger.kernel.org; sameo@linux.intel.com
> > Cc: broonie@kernel.org; J, KEERTHY; ldewangan@nvidia.com;
> > grant.likely@secretlab.ca; swarren@nvidia.com; linux-
> > kernel@vger.kernel.org; linux-doc@vger.kernel.org; gg@slimlogic.co.uk
> > Subject: [PATCH 4/4] regulator: Palmas: Add TPS659038 support
> >
> > Add TPS659038 support.
> >
> 
> Could you pull this one too?

A gentle ping on this.

> 
> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > Acked-by: Mark Brown <broonie@linaro.org>
> > ---
> >  drivers/regulator/palmas-regulator.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/regulator/palmas-regulator.c
> > b/drivers/regulator/palmas-regulator.c
> > index 1ae1e83..d0c8785 100644
> > --- a/drivers/regulator/palmas-regulator.c
> > +++ b/drivers/regulator/palmas-regulator.c
> > @@ -1054,6 +1054,7 @@ static struct of_device_id
> of_palmas_match_tbl[]
> > = {
> >  	{ .compatible = "ti,tps65913-pmic", },
> >  	{ .compatible = "ti,tps65914-pmic", },
> >  	{ .compatible = "ti,tps80036-pmic", },
> > +	{ .compatible = "ti,tps659038-pmic", },
> >  	{ /* end */ }
> >  };
> >
> > --
> > 1.7.5.4
> 
> Regards,
> Keerthy

Regards,
Keerthy
