Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422919Ab3FUJHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:07:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38515 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161353Ab3FUJHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:07:14 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: RE: [PATCH 2/4] MFD: Palmas: Add TPS659038 PMIC support
Thread-Topic: [PATCH 2/4] MFD: Palmas: Add TPS659038 PMIC support
Thread-Index: AQHObaY940mmlA2QH0SGEMxdlPp4eZk/4bAw
Date: Fri, 21 Jun 2013 09:06:49 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229EDC73@DBDE04.ent.ti.com>
References: <1371726316-10078-1-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1371726316-10078-1-git-send-email-j-keerthy@ti.com>
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

Hello Samuel,

> -----Original Message-----
> From: J, KEERTHY
> Sent: Thursday, June 20, 2013 4:35 PM
> To: linux-omap@vger.kernel.org; sameo@linux.intel.com
> Cc: broonie@kernel.org; J, KEERTHY; ldewangan@nvidia.com;
> grant.likely@secretlab.ca; swarren@nvidia.com; linux-
> kernel@vger.kernel.org; linux-doc@vger.kernel.org; devicetree-
> discuss@lists.ozlabs.org; gg@slimlogic.co.uk
> Subject: [PATCH 2/4] MFD: Palmas: Add TPS659038 PMIC support
> 
> The Patch adds TPS659038 PMIC support in the palmas mfd driver.
> The TPS659038 has almost the same registers as of the earlier supported
> variants of PALMAS family such as the TWL6035.
> 
> The critical differences between TPS659038 and TWL6035 being:
> 
> 1) TPS659038 has nothing related to battery charging and back up
> battery stuff.
> 2) TPS659038 does not have does not have SMPS10(Boost) step up
> convertor.
> 3) TPS659038 does not have Battery detection and anything related to
> battery.
> 4) SD card detection, Battery presence detection, Vibrator, USB OTG are
> missing
>    when compared to TWL6035.
> 

Could you please pull this patch?

> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/mfd/palmas.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c index
> ad2edd6..8b20055 100644
> --- a/drivers/mfd/palmas.c
> +++ b/drivers/mfd/palmas.c
> @@ -233,12 +233,17 @@ static void palmas_dt_to_pdata(struct i2c_client
> *i2c,  }
> 
>  static unsigned int palmas_features =
> PALMAS_PMIC_FEATURE_SMPS10_BOOST;
> +static unsigned int tps659038_features;
> 
>  static const struct of_device_id of_palmas_match_tbl[] = {
>  	{
>  		.compatible = "ti,palmas",
>  		.data = &palmas_features,
>  	},
> +	{
> +		.compatible = "ti,tps659038",
> +		.data = &tps659038_features,
> +	},
>  	{ },
>  };
> 
> --
> 1.7.5.4

Regards,
Keerthy
