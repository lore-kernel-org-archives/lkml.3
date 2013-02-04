Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab3BDN2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:28:47 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40418 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab3BDN2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:28:45 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "Porter, Matt" <mporter@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "hs@denx.de" <hs@denx.de>, "ido@wizery.com" <ido@wizery.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 2/3] mmc: davinci_mmc: add DT support
Thread-Topic: [PATCH 2/3] mmc: davinci_mmc: add DT support
Thread-Index: AQHN/6AOnO46wGG8wEe+w9SUfqhxIphi7zeAgAGo6JA=
Date: Mon, 4 Feb 2013 13:28:14 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3EA46049@DBDE01.ent.ti.com>
References: <1359628387-14437-1-git-send-email-prakash.pm@ti.com>
 <1359628387-14437-3-git-send-email-prakash.pm@ti.com>
 <20130131112303.GA7235@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130131112303.GA7235@e106331-lin.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: =?us-ascii?Q?JL3+_Q4gk_SEKB_cb5L_dS4j_gMZJ_0WUs_AFsmfQ=3D=3D_AGSXNg=3D=3D?=
 =?us-ascii?B?IEFIb2czUT09IEFOTlQ2Zz09IEFOdzVydz09IEFSQXp3dz09IEFSOEErZz09?=
 =?us-ascii?Q?_ASTinA=3D=3D_ASqqfw=3D=3D;13;YwBqAGIAQABsAGEAcAB0AG8AcAAuAG?=
 =?us-ascii?Q?8AcgBnADsAZABhAHYAaQBuAGMAaQAtAGwAaQBuAHUAeAAtAG8AcABlAG4ALQ?=
 =?us-ascii?Q?BzAG8AdQByAGMAZQBAAGwAaQBuAHUAeAAuAGQAYQB2AGkAbgBjAGkAZABzAH?=
 =?us-ascii?Q?AALgBjAG8AbQA7AGQAZQB2AGkAYwBlAHQAcgBlAGUALQBkAGkAcwBjAHUAcw?=
 =?us-ascii?Q?BzAEAAbABpAHMAdABzAC4AbwB6AGwAYQBiAHMALgBvAHIAZwA7AGcAcgBlAG?=
 =?us-ascii?Q?cAawBoAEAAbABpAG4AdQB4AGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZw?=
 =?us-ascii?Q?A7AGgAcwBAAGQAZQBuAHgALgBkAGUAOwBpAGQAbwBAAHcAaQB6AGUAcgB5AC?=
 =?us-ascii?Q?4AYwBvAG0AOwBsAGkAbgB1AHgALQBhAHIAbQAtAGsAZQByAG4AZQBsAEAAbA?=
 =?us-ascii?Q?BpAHMAdABzAC4AaQBuAGYAcgBhAGQAZQBhAGQALgBvAHIAZwA7AGwAaQBuAH?=
 =?us-ascii?Q?UAeAAtAGQAbwBjAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOw?=
 =?us-ascii?Q?BsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAG?=
 =?us-ascii?Q?UAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AbQBtAGMAQAB2AGcAZQByAC4Aaw?=
 =?us-ascii?Q?BlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeABAAGEAcgBtAC4AbABpAG?=
 =?us-ascii?Q?4AdQB4AC4AbwByAGcALgB1AGsAOwBtAGEAcgBrAC4AcgB1AHQAbABhAG4AZA?=
 =?us-ascii?Q?BAAGEAcgBtAC4AYwBvAG0AOwByAG8AYgAuAGgAZQByAHIAaQBuAGcAQABjAG?=
 =?us-ascii?Q?EAbAB4AGUAZABhAC4AYwBvAG0A;Sosha1=5Fv1;7;{9DF94E9E-F3DB-41B1?=
 =?us-ascii?Q?-BDE7-4746B8ABF279};cAByAGEAawBhAHMAaAAuAHAAbQBAAHQAaQAuAGMA?=
 =?us-ascii?Q?bwBtAA=3D=3D;Mon,_04_Feb_2013_13:27:36_GMT;UgBFADoAIABbAFAAQ?=
 =?us-ascii?Q?QBUAEMASAAgADIALwAzAF0AIABtAG0AYwA6ACAAZABhAHYAaQBuAGMAaQBfA?=
 =?us-ascii?Q?G0AbQBjADoAIABhAGQAZAAgAEQAVAAgAHMAdQBwAHAAbwByAHQA?=
x-cr-puzzleid: {9DF94E9E-F3DB-41B1-BDE7-4746B8ABF279}
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Jan 31, 2013 at 16:53:03, Mark Rutland wrote:
> Hello,
> 
> I have a few comments on the devicetree binding and the way it's parsed.
> 

Thanks for review.

> On Thu, Jan 31, 2013 at 10:33:06AM +0000, Manjunathappa, Prakash wrote:
> > Adds device tree support for davinci_mmc. Also add
> > binding documentation.
> > Tested with non-dma PIO mode and without GPIO
> > card_detect/write_protect option because of
> > dependencies on EDMA and GPIO modules DT support.
> > 
> > Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
> > Cc: linux-mmc@vger.kernel.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: davinci-linux-open-source@linux.davincidsp.com
> > Cc: devicetree-discuss@lists.ozlabs.org
> > Cc: cjb@laptop.org
> > Cc: Sekhar Nori <nsekhar@ti.com>
> > Cc: mporter@ti.com
> > ---
> >  .../devicetree/bindings/mmc/davinci_mmc.txt        |   23 +++++++
> >  drivers/mmc/host/davinci_mmc.c                     |   69 +++++++++++++++++++-
> >  2 files changed, 91 insertions(+), 1 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/mmc/davinci_mmc.txt b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> > new file mode 100644
> > index 0000000..144bee6
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> > @@ -0,0 +1,23 @@
> > +* TI Highspeed MMC host controller for DaVinci
> > +
> > +The Highspeed MMC Host Controller on TI DaVinci family
> > +provides an interface for MMC, SD and SDIO types of memory cards.
> > +
> > +This file documents differences between the core properties described
> > +by mmc.txt and the properties used by the davinci_mmc driver.
> > +
> > +Required properties:
> > +- compatible:
> > + Should be "ti,davinci_mmc", for davinci controllers
> 
> "ti,davinci-mmc" (with '-' rather than '_') would be preferable.
> 

I agree, will correct it.

> > +
> > +Optional properties:
> > +- bus-width: Number of data lines, can be <1>, <4>, or <8>, default <1>
> > +- max-frequency: maximum operating clock frequency.
> 
> You said you only described differences from mmc.txt, but this is listed in
> mmc.txt.
> 

Agreed, I will remove it from here.

> > +- caps: Check for Host capabilities in <linux/mmc/host.h>
> 
> Is this a set of binary flags? Also, is this Linux-specific?
> 
> I really don't think this should be in the devicetree binding. Why do you need
> this?
> 

I was using this to specify the below controller capabilities:
MMC_CAP_MMC_HIGHSPEED and MMC_CAP_SD_HIGHSPEED,
Found from discussion[1] that this can be derived from max-frequency,
That is above capabilities are supported when max-frequency >= 50MHz.

[1] https://lkml.org/lkml/2012/10/15/231

> > +- version: version of controller.
> 
> This should be encoded as part of the compatible string.
> 

Agreed will make change accordingly to accommodate version info in compatible string.

> > +Example:
> > +	mmc1: mmc@0x4809c000 {
> > +		compatible = "ti,omap4-hsmmc";
> > +		reg = <0x4809c000 0x400>;
> > +		bus-width = <4>;
> > +	};
> 
> It would be nice if the example referred to this binding rather than another.
> 

Agreed, I will change.

> > diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> > index 382b79d..ce6730d 100644
> > --- a/drivers/mmc/host/davinci_mmc.c
> > +++ b/drivers/mmc/host/davinci_mmc.c
> > @@ -34,6 +34,7 @@
> >  #include <linux/dma-mapping.h>
> >  #include <linux/edma.h>
> >  #include <linux/mmc/mmc.h>
> > +#include <linux/of.h>
> >  
> >  #include <linux/platform_data/mmc-davinci.h>
> >  
> > @@ -1156,16 +1157,75 @@ static void __init init_mmcsd_host(struct mmc_davinci_host *host)
> >  
> >  	mmc_davinci_reset_ctrl(host, 0);
> >  }
> > +#ifdef CONFIG_OF
> > +static struct davinci_mmc_config
> > +	*mmc_of_get_pdata(struct platform_device *pdev)
> > +{
> > +	struct device_node *np;
> > +	struct davinci_mmc_config *pdata = NULL;
> > +	u32 data;
> > +	int ret;
> > +
> > +	pdata = pdev->dev.platform_data;
> > +	if (!pdata) {
> > +		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> > +		if (!pdata) {
> > +			dev_err(&pdev->dev, "Failed to allocate memory for struct davinci_mmc_config\n");
> > +			goto nodata;
> > +		}
> > +	}
> 
> Why do you need to conditionally allocate this? This only seems to be called
> once.
> 

This is common function for DT and non-DT kernel(will be removing #ifdef CONFIG_OF),
So above check is necessary for to allocate pdata for DT kernel.

> > +
> > +	np = pdev->dev.of_node;
> > +	if (!np)
> > +		goto nodata;
> 
> Why not just return immediately here? You do nothing special at nodata.
> 

Following convention to not have more than 1 return from function and have
Common exit point. May not be necessary now since we have devm_* calls now.
Can I still prefer to keep this goto?

> > +
> > +	ret = of_property_read_u32(np, "bus-width", &data);
> > +	if (ret)
> > +		dev_info(&pdev->dev, "wires not specified, defaulting to 4 bit mode\n");
> > +	pdata->wires = data;
> 
> That dev_info doesn't seem to match up with what the next line is doing (data
> might not have been initialised). Also, unless I've misunderstood, it doesn't
> match up with the default of 1 mentioned in the binding doc.
> 

Yes with missing bus-width property module comes in 1 bit mode, I will correct it.

> > +
> > +	ret = of_property_read_u32(np, "max-frequency", &data);
> > +	if (ret)
> > +		dev_info(&pdev->dev, "max-frequency not specified, defaulting to 25MHz\n");
> > +	pdata->max_freq = data;
> 
> Again, the dev_info doesn't match up with the line below it. I notice
> the default's not one specified in the binding. Is this frequency chosen
> from the hardware docs, or is it an arbitrary choice. If not arbitrary,
> it might be worth specifying in the binding.
> 

Agreed, I will make the changes for the default values.

> 
> > +
> > +	ret = of_property_read_u32(np, "caps", &data);
> > +	if (ret)
> > +		dev_info(&pdev->dev, "card capability not specified\n");
> > +	pdata->caps = data;
> 
> Again, you may be using garbage data.
> 

Ok I will correct it.

> > +
> > +	ret = of_property_read_u32(np, "version", &data);
> > +	if (ret)
> > +		dev_err(&pdev->dev, "version not specified\n");
> > +	pdata->version = data;
> 
> And again, though I'd prefer to see this property go entirely.
> 

Yes this is going to go away.

> > +
> > +nodata:
> > +	return pdata;
> > +}
> > +
> > +#else
> > +static struct davinci_mmc_config
> > +	*mmc_of_get_pdata(struct platform_device *pdev)
> > +{
> > +	return pdev->dev.platform_data;
> > +}
> > +#endif
> 
> This is poorly named if it's required for !CONFIG_OF.
> 
> Why not change this to something like mmc_parse_pdata, returning an
> error code. For !CONFIG_OF, it can simply return 0, which should be less
> surprising for anyone else reading this code.
> 

I will remove #ifdef CONFIG_OF conditional compilation and consideration
your suggestion to name function as mmc_parse_pdata.

> >  
> >  static int __init davinci_mmcsd_probe(struct platform_device *pdev)
> >  {
> > -	struct davinci_mmc_config *pdata = pdev->dev.platform_data;
> > +	struct davinci_mmc_config *pdata = NULL;
> >  	struct mmc_davinci_host *host = NULL;
> >  	struct mmc_host *mmc = NULL;
> >  	struct resource *r, *mem = NULL;
> >  	int ret = 0, irq = 0;
> >  	size_t mem_size;
> >  
> > +	pdata = mmc_of_get_pdata(pdev);
> > +	if (pdata == NULL) {
> > +		dev_err(&pdev->dev, "Can not get platform data\n");
> > +		return -ENOENT;
> > +	}
> > +
> >  	/* REVISIT:  when we're fully converted, fail if pdata is NULL */
> >  
> >  	ret = -ENODEV;
> > @@ -1403,11 +1463,18 @@ static const struct dev_pm_ops davinci_mmcsd_pm = {
> >  #define davinci_mmcsd_pm_ops NULL
> >  #endif
> >  
> > +static const struct of_device_id davinci_mmc_of_match[] = {
> > +	{.compatible = "ti,davinci_mmc", },
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(of, davinci_mmc_of_match);
> 
> For supporting multiple versions, you could either use some auxdata
> here, or check each one in davince_mmcsd_probe.
> 

I will consider keeping auxdata via compatible field.

> > +
> >  static struct platform_driver davinci_mmcsd_driver = {
> >  	.driver		= {
> >  		.name	= "davinci_mmc",
> >  		.owner	= THIS_MODULE,
> >  		.pm	= davinci_mmcsd_pm_ops,
> > +		.of_match_table = of_match_ptr(davinci_mmc_of_match),
> >  	},
> >  	.remove		= __exit_p(davinci_mmcsd_remove),
> >  };
> 
> Where does davinci_mmcsd_probe get called from, and how is the
> of_match_table used? Should it not be set as .probe on the driver?
> 

Driver probe is registered in module_init. 
And are you suggesting me to use module_platform_driver? If yes can it not
be taken separately as it is unrelated to DT support I am adding.

of_match_table is used by device tree. (will point to NULL for !CONFIG_OF)

Thanks,
Prakash
