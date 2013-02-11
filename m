Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab3BKF02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 00:26:28 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:34043 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab3BKF01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 00:26:27 -0500
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>
Subject: RE: [PATCH] Regulator: Reorder the min max assignment in the
 sequence of regulator_set_voltage function
Thread-Topic: [PATCH] Regulator: Reorder the min max assignment in the
 sequence of regulator_set_voltage function
Thread-Index: AQHOADnufPb44Tk3JkCHdcW8IZFak5hvgkUAgASta0A=
Date: Mon, 11 Feb 2013 05:26:20 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229B95A0@DBDE01.ent.ti.com>
References: <1359695098-3630-1-git-send-email-j-keerthy@ti.com>
 <20130208112848.GM8879@opensource.wolfsonmicro.com>
In-Reply-To: <20130208112848.GM8879@opensource.wolfsonmicro.com>
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

Hi Mark,

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Friday, February 08, 2013 4:59 PM
> To: J, KEERTHY
> Cc: linux-kernel@vger.kernel.org; lgirdwood@gmail.com
> Subject: Re: [PATCH] Regulator: Reorder the min max assignment in the
> sequence of regulator_set_voltage function
> 
> On Fri, Feb 01, 2013 at 10:34:58AM +0530, J Keerthy wrote:
> 
> > +++ b/drivers/regulator/core.c
> > @@ -81,6 +81,8 @@ struct regulator {
> >  	int uA_load;
> >  	int min_uV;
> >  	int max_uV;
> > +	int curr_min_uV;
> > +	int curr_max_uV;
> 
> This change makes sense but I don't see why we need to add these to
> struct regulator - why not just store the values locally for unwinding?

Ok. I will send an updated patch. Thanks for the response
And sorry for the top posting.

Regards,
Keerthy
