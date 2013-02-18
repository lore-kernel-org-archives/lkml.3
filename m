Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab3BRIfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 03:35:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45438 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab3BRIfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:35:04 -0500
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/4] regulator: palmas: Removing duplicated code
Thread-Topic: [PATCH 3/4] regulator: palmas: Removing duplicated code
Thread-Index: AQHODZbzlruKrwrzB0+4blbrifIXF5h+61KAgABe9uA=
Date: Mon, 18 Feb 2013 08:34:55 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229BB514@DBDE01.ent.ti.com>
References: <1361164446-3216-1-git-send-email-j-keerthy@ti.com>
 <5121E535.6040309@slimlogic.co.uk>
In-Reply-To: <5121E535.6040309@slimlogic.co.uk>
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
> From: Graeme Gregory [mailto:gg@slimlogic.co.uk]
> Sent: Monday, February 18, 2013 1:54 PM
> To: J, KEERTHY
> Cc: broonie@opensource.wolfsonmicro.com; lgirdwood@gmail.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 3/4] regulator: palmas: Removing duplicated code
> 
> 
> On 18/02/13 05:14, J Keerthy wrote:
> > Removing duplicate assignment in the existing code.
> >
> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > ---
> >  drivers/regulator/palmas-regulator.c |    5 -----
> >  1 files changed, 0 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/regulator/palmas-regulator.c
> b/drivers/regulator/palmas-regulator.c
> > index c9e912f..22c6ae2 100644
> > --- a/drivers/regulator/palmas-regulator.c
> > +++ b/drivers/regulator/palmas-regulator.c
> > @@ -566,11 +566,6 @@ static void palmas_dt_to_pdata(struct device
> *dev,
> >  			pdata->reg_init[idx]->mode_sleep = prop;
> >
> >  		ret = of_property_read_u32(palmas_matches[idx].of_node,
> > -				"ti,warm_reset", &prop);
> > -		if (!ret)
> > -			pdata->reg_init[idx]->warm_reset = prop;
> > -
> > -		ret = of_property_read_u32(palmas_matches[idx].of_node,
> >  				"ti,tstep", &prop);
> >  		if (!ret)
> >  			pdata->reg_init[idx]->tstep = prop;
> This hunk has already been upstreamed by Axel Lin.

Ok. Thanks Graeme. I had missed this.

> 
> http://git.kernel.org/?p=linux/kernel/git/next/linux-
> next.git;a=commit;h=f33d0081ff3ffb7180a9794e60318458d7671b36
> 
> Graeme

