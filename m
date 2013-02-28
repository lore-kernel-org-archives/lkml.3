Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992Ab3B1FWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 00:22:43 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46042 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3B1FWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 00:22:42 -0500
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: RE: [PATCH 3/4] regulator: palmas: Removing duplicated code
Thread-Topic: [PATCH 3/4] regulator: palmas: Removing duplicated code
Thread-Index: AQHODZbzlruKrwrzB0+4blbrifIXF5iNuv4AgAEPVaA=
Date: Thu, 28 Feb 2013 05:22:30 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229BCD0A@DBDE01.ent.ti.com>
References: <1361164446-3216-1-git-send-email-j-keerthy@ti.com>
 <512E51E4.902@wwwdotorg.org>
In-Reply-To: <512E51E4.902@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.159.88]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Thursday, February 28, 2013 12:05 AM
> To: J, KEERTHY
> Cc: broonie@opensource.wolfsonmicro.com; lgirdwood@gmail.com; linux-
> kernel@vger.kernel.org; gg@slimlogic.co.uk
> Subject: Re: [PATCH 3/4] regulator: palmas: Removing duplicated code
> 
> On 02/17/2013 10:14 PM, J Keerthy wrote:
> > Removing duplicate assignment in the existing code.
> ...
> > diff --git a/drivers/regulator/palmas-regulator.c
> > b/drivers/regulator/palmas-regulator.c
> ...
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
> 
> Can you point out where the duplicate of that is; I don't see any other
> assignment to warm_reset.

As pointed out by Graeme this is already fixed.

Regards,
Keerthy
