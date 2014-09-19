Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbaISJSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 05:18:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18825 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaISJSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 05:18:47 -0400
X-AuditID: cbfee68f-f797f6d000001173-df-541bf4f41c05
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Dong Aisheng'" <b29396@freescale.com>,
        "'Xiubo Li-B47053'" <Li.Xiubo@freescale.com>
Cc: "'Dong Aisheng-B29396'" <Aisheng.Dong@freescale.com>, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, linux@arm.linux.org.uk, naushad@samsung.com,
        tomasz.figa@gmail.com, joshi@samsung.com, thomas.ab@samsung.com,
        vikas.sajjan@samsung.com, chow.kim@samsung.com, lee.jones@linaro.org,
        "'Boris BREZILLON'" <boris.brezillon@free-electrons.com>,
        "'Geert Uytterhoeven'" <geert+renesas@glider.be>,
        "'Stephen Warren'" <swarren@nvidia.com>
References: <20140917085818.GA10285@shlinux1.ap.freescale.net>
 <000401cfd269$922dfc40$b689f4c0$@samsung.com>
 <20140918030552.GA26661@shlinux1.ap.freescale.net>
 <000701cfd306$4d3e8080$e7bb8180$@samsung.com>
 <20140918075516.GB15363@shlinux1.ap.freescale.net>
 <000c01cfd324$1f2cd930$5d868b90$@samsung.com>
 <20140918100505.GA19346@shlinux1.ap.freescale.net>
 <48f9f4067cc44ad49297bb4b62c56c88@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <20140919041933.GB19346@shlinux1.ap.freescale.net>
 <8e0ba684d5fe4663a8842336385ed7ad@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <20140919054602.GC19346@shlinux1.ap.freescale.net>
In-reply-to: <20140919054602.GC19346@shlinux1.ap.freescale.net>
Subject: RE: [PATCH v3] mfd: syscon: Decouple syscon interface from platform
 devices
Date: Fri, 19 Sep 2014 14:50:37 +0530
Message-id: <000c01cfd3eb$0cd0a790$2671f6b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQMenyfb7t7Sr4j0frmAYMHLuGtF5QCImyw6Aj6DrBACOxOvaQCdeIcRAbPMcSsBnGOBwQHDHVpkAdOmWzgBuXxUIwJcRq0imOWtI9A=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWyRsSkWvfLF+kQg5bb/BYLlr5lsfg76Ri7
	xcOd/SwWB14sZLFYNukum8Xc2ZMYLb7v+sJu0bvgKpvF/a9HGS06L3SwWmx6fI3V4vKuOWwW
	M87vY7K4fZnX4tPR/6wWN6a3sFp0LGO0WLXrD6PFzWfbmRyEPVqae9g8fv+axOjxZNNFRo9/
	h/uZPCae1fXYOesuu8eda3vYPDYvqffobX7H5tG3ZRWjx+dNcgHcUVw2Kak5mWWpRfp2CVwZ
	W6dNZS845F+xtDGwgXGCVRcjJ4eEgInE2jn3mSFsMYkL99azdTFycQgJLGWUmPTqBDtM0Zq5
	U1ghEtMZJc53zmOGcP4ySmxfsZQFpIpNQFfiyfu5YKNEBMIlPv04D1bELDCFRWL7tpeMEB1f
	WSSWLrnGClLFKWAvsW1yD9gOYYEwiau958FsFgFViZb/+8Cm8gpYSpy/fJsVwhaU+DH5Hlic
	WUBLYv3O40wQtrzE5jVvoZ5QkNhx9jXQMg6gKyokGmfJQpSIS0x68JAd5AYJgRccEm3HdzBD
	7BKQ+Db5EAtIvYSArMSmA1BjJCUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5K
	LzLWK07MLS7NS9dLzs/dxAhMNqf/PevfwXj3gPUhRgEORiUeXs806RAh1sSy4srcQ4ymQBdN
	ZJYSTc4HprS8knhDYzMjC1MTU2Mjc0szJXHehVI/g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFw
	SjUwttRlJCwpad/p587Ez/vUL8c1ZytH5pIy3clZVnenG2zc1H5wb8NHkTjBNfsfZiSy7fi0
	JUrV5JPt+SQGzg2+mZf1fu/MS5scVyRocefq9xuzJqmW3Tldd+eTnse6gEevFuvf+ZvmNbdd
	TqNkOqsUg3v1y43bT9hWK6nbMJg8feR5xPXY94pJSizFGYmGWsxFxYkAP1+KMDEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsVy+t9jQd0vX6RDDB7dYrJYsPQti8XfScfY
	LR7u7GexOPBiIYvFskl32Szmzp7EaPF91xd2i94FV9ks7n89ymjReaGD1WLT42usFpd3zWGz
	mHF+H5PF7cu8Fp+O/me1uDG9hdWiYxmjxapdfxgtbj7bzuQg7NHS3MPm8fvXJEaPJ5suMnr8
	O9zP5DHxrK7Hzll32T3uXNvD5rF5Sb1Hb/M7No++LasYPT5vkgvgjmpgtMlITUxJLVJIzUvO
	T8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB+k5JoSwxpxQoFJBYXKykb4dp
	QmiIm64FTGOErm9IEFyPkQEaSFjDmLF12lT2gkP+FUsbAxsYJ1h1MXJySAiYSKyZO4UVwhaT
	uHBvPVsXIxeHkMB0RonznfOYIZy/jBLbVyxlAaliE9CVePJ+LjOILSIQLvHpx3mwImaBKSwS
	27e9ZITo+MoisXTJNbC5nAL2Etsm97CD2MICYRJXe8+D2SwCqhIt//eBTeUVsJQ4f/k2K4Qt
	KPFj8j2wOLOAlsT6nceZIGx5ic1r3jJD3KogsePsa6BlHEBXVEg0zpKFKBGXmPTgIfsERqFZ
	SCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnMqeSe9gXNVgcYhR
	gINRiYfXI006RIg1say4MvcQowQHs5II76cPQCHelMTKqtSi/Pii0pzU4kOMpkCPTmSWEk3O
	B6bZvJJ4Q2MTc1NjU0sTCxMzSyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFINjGwXqlQ1rAvL
	dysF5esyn956xlqhY1vGQvmYL7/X/HE8+2TJb44P4XdSrNXb7lTf/KUVtHvKosUb3l2L2Mrw
	tdT8zqYJixVyv984YXi06e7xtQczrrxJi677trhXuTt6Y62PmV2FaHFq5boClfNHey+nlcgt
	ydosYbVy97SY00aM377U3Ni776gSS3FGoqEWc1FxIgCbJ9fTewMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dong and Xiubo,

On  Friday, September 19, 2014, Dong Aisheng wrote,
> On Fri, Sep 19, 2014 at 01:20:18PM +0800, Xiubo Li-B47053 wrote:
> > [...]
> > > >    create child: /dcsr@20000000/dcsr-atbrepl@3a8000
> > > >    create child: /dcsr@20000000/dcsr-tsgen-ctrl@3a9000
> > > >    create child: /dcsr@20000000/dcsr-tsgen-read@3aa000
> > > >    create child: /regulators/regulator@0
> > > >    ...
> > > >
> > > > As default the Linux will create all the platform device for each
> > > > DT node,
> > > which
> > > > Can be found from "drivers/of/platform.c".
> > > >
> > > > So we can get the pdev node using the specified DT node, and feel
> > > > safe to
> > > use
> > > > it as Pankaj's patch does.
> > > >
> > >
> > > I mean before the devices are populated from device tree.
> > > For example, we usually call of_platform_populate in .init_machine.
> > > Before it, we may not be able to get it's device, isn't it?
> > >
> >
> > Yes, right.
> >
> > For this case, we'd better create the pdev or dev manually for the
> > first time We use it, right ?
> 
> Yes, that's my understanding.
> 

Thanks for all your inputs. 

First let me clarify that the main purpose of this patch, we introduced this
patch mainly because 
if some HW IP is having secondary compatibility as "syscon", syscon driver
was getting probed
and since there can be only on platform_device corresponding to one
device_node, actual driver
corresponding to that HW IP was not getting probed. So we wanted to decouple
syscon from platform
device, and any such driver should be able to become syscon provider. Please
see discussion here [1].

[1]: https://lkml.org/lkml/2014/6/17/331

But while doing so eventually this patch was also able to cover the feature
of early availability of syscon
lookup APIs.

As both of you pointed out that if we use "of_find_device_by_node" and it
won't work for early users
of syscon. I also agree with that, but it just skipped from my mind while
suggesting that approach.

I reconsidered again and made following changes and tested it. Now I am able
to use syscon_lookup_by_xxxxx 
APIs, very early (before dt_machine_init) as well as after
of_platform_populate. So please review and if
it is acceptable I will post next version of this patch.

Basic idea is, check for device_node pointer in of_syscon_register, if
device corresponding to that device_node
is already populated and available use "of_find_device_by_node" else create
a dummy platform device and then
use it.

----------
static struct syscon *of_syscon_register(struct device_node *np)
 {
+	struct platform_device *pdev = NULL;
 	struct syscon *syscon;
 	struct regmap *regmap;
 	void __iomem *base;
 
+	struct platform_device dummy_pdev = {
+		.name              = "dummy-syscon",
+		.id                = -1,
+	};
+
 	if (!of_device_is_compatible(np, "syscon"))
 		return ERR_PTR(-EINVAL);
 
@@ -141,8 +149,22 @@ static struct syscon *of_syscon_register(struct
device_node *np)
 	base = of_iomap(np, 0);
 	if (!base)
 		return ERR_PTR(-ENOMEM);
+ 
+	if (!of_device_is_available(np) ||
+			of_node_test_and_set_flag(np, OF_POPULATED)) {
+		/* if device is already populated and avaiable then use it
*/
+		pdev = of_find_device_by_node(np);
+		if (!(&pdev->dev))
+			return ERR_PTR(-ENODEV);
+
+		regmap = regmap_init_mmio(&pdev->dev, base,
&syscon_regmap_config);
+	} else {
+		/* for early users let's create dummy syscon device and use
it */
+		device_initialize(&dummy_pdev.dev);
+		dummy_pdev.dev.of_node = np;
+		regmap = regmap_init_mmio(&dummy_pdev.dev, base,
&syscon_regmap_config);
+	}
 
-	regmap = regmap_init_mmio(NULL, base, &syscon_regmap_config);
 	if (IS_ERR(regmap)) {
 		pr_err("regmap init failed\n");
 		return ERR_CAST(regmap);
--


Thanks,
Pankaj Dubey

> Regards
> Dong Aisheng
> 
> >
> > Thanks,
> >
> > BRs
> > Xiubo
> >
> >
> > > Regards
> > > Dong Aisheng
> > >
> > > > And also we must make sure that the 'syscon' DT nodes has the
> > > > compatible
> > > prop.
> > > >
> > > > Thanks,
> > > >
> > > > BRs
> > > > Xiubo
> > > >
> > > >
> > > > > Regards
> > > > > Dong Aisheng
> > > > >
> > > > > > ----
> > > > > > static struct syscon *of_syscon_register(struct device_node
> > > > > > *np)  {
> > > > > > +	struct platform_device *pdev;
> > > > > >  	struct syscon *syscon;
> > > > > >  	struct regmap *regmap;
> > > > > >  	void __iomem *base;
> > > > > > @@ -142,7 +144,11 @@ static struct syscon
> > > > > > *of_syscon_register(struct device_node *np)
> > > > > >  	if (!base)
> > > > > >  		return ERR_PTR(-ENOMEM);
> > > > > >
> > > > > > -	regmap = regmap_init_mmio(NULL, base,
&syscon_regmap_config);
> > > > > > +	pdev = of_find_device_by_node(np);
> > > > > > +	if (!(&pdev->dev))
> > > > > > +		return ERR_PTR(-ENODEV);
> > > > > > +
> > > > > > +	regmap = regmap_init_mmio(&pdev->dev, base,
> > > &syscon_regmap_config);
> > > > > >  	if (IS_ERR(regmap)) {
> > > > > >  		pr_err("regmap init failed\n");
> > > > > >  		return ERR_CAST(regmap);
> > > > > > -------
> > > > > >
> > > > > > I have tested this in linux-next and it works well. In this
> > > > > > way there
> > > won't
> > > > > > be any issues of
> > > > > > dereferencing NULL pointer in regmap.c and at the same time,
> > > > > > if DT has {big,little}-endian optional property in syscon
> > > > > > device node, it will be taken care.
> > > > > >
> > > > > > So I would wait for Arnd's opinion about above mentioned
> > > > > > changes and
> > > then
> > > > > > post a new
> > > > > > change after addressing Arnd's minor comment along with this
> > > > > > fix in next revision.
> > > > > >
> > > > > >
> > > > > > Thanks,
> > > > > > Pankaj Dubey
> > > > > > > Maybe we could consider create device structure for each
> > > > > > > syscon
> > > compatible
> > > > > > device in
> > > > > > > syscon driver in of_syscon_register in first time which
> > > > > > > seems to be
> > > > > > reasonable.
> > > > > > >
> > > > > > > Regards
> > > > > > > Dong Aisheng
> > > > > > >
> > > > > > > > --------------------------------------------
> > > > > > > > Subject: [PATCH] regmap: fix NULL pointer dereference in
> > > > > > > > regmap_get_val_endian
> > > > > > > >
> > > > > > > > Recent commits for getting reg endianess causing NULL
> > > > > > > > pointer dereference if dev is passed NULL in
> > > > > > > > regmap_init_mmio. This patch fixes this issue, and allows
> > > > > > > > to parse reg endianess only if dev and
> > > > > > > > dev->of_node exist.
> > > > > > > >
> > > > > > > > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > > > > > > > ---
> > > > > > > >  drivers/base/regmap/regmap.c |   23 ++++++++++++++-------
> --
> > > > > > > >  1 file changed, 14 insertions(+), 9 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/drivers/base/regmap/regmap.c
> > > > > > > > b/drivers/base/regmap/regmap.c index f2281af..455a877
> > > > > > > > 100644
> > > > > > > > --- a/drivers/base/regmap/regmap.c
> > > > > > > > +++ b/drivers/base/regmap/regmap.c
> > > > > > > > @@ -477,7 +477,7 @@ static enum regmap_endian
> > > > > > > > regmap_get_val_endian(struct device *dev,
> > > > > > > >  					const struct
regmap_bus *bus,
> > > > > > > >  					const struct
regmap_config
> *config)
> > > > > > {
> > > > > > > > -	struct device_node *np = dev->of_node;
> > > > > > > > +	struct device_node *np;
> > > > > > > >  	enum regmap_endian endian;
> > > > > > > >
> > > > > > > >  	/* Retrieve the endianness specification from the
regmap
> > > > > > > > config
> > > > > */
> > > > > > > > @@ -487,15 +487,20 @@ static enum regmap_endian
> > > > > > > > regmap_get_val_endian(struct device *dev,
> > > > > > > >  	if (endian != REGMAP_ENDIAN_DEFAULT)
> > > > > > > >  		return endian;
> > > > > > > >
> > > > > > > > -	/* Parse the device's DT node for an endianness
specification
> */
> > > > > > > > -	if (of_property_read_bool(np, "big-endian"))
> > > > > > > > -		endian = REGMAP_ENDIAN_BIG;
> > > > > > > > -	else if (of_property_read_bool(np, "little-endian"))
> > > > > > > > -		endian = REGMAP_ENDIAN_LITTLE;
> > > > > > > > +	/* If the dev and dev->of_node exist try to get
> > > > > > > > +endianness from
> > > > > DT
> > > > > > > > */
> > > > > > > > +	if (dev && dev->of_node) {
> > > > > > > > +		np = dev->of_node;
> > > > > > > >
> > > > > > > > -	/* If the endianness was specified in DT, use that
*/
> > > > > > > > -	if (endian != REGMAP_ENDIAN_DEFAULT)
> > > > > > > > -		return endian;
> > > > > > > > +		/* Parse the device's DT node for an
endianness
> > > > > > > > specification */
> > > > > > > > +		if (of_property_read_bool(np, "big-endian"))
> > > > > > > > +			endian = REGMAP_ENDIAN_BIG;
> > > > > > > > +		else if (of_property_read_bool(np,
"little-endian"))
> > > > > > > > +			endian = REGMAP_ENDIAN_LITTLE;
> > > > > > > > +
> > > > > > > > +		/* If the endianness was specified in DT,
use that */
> > > > > > > > +		if (endian != REGMAP_ENDIAN_DEFAULT)
> > > > > > > > +			return endian;
> > > > > > > > +	}
> > > > > > > >
> > > > > > > >  	/* Retrieve the endianness specification from the
bus config */
> > > > > > > >  	if (bus && bus->val_format_endian_default)
> > > > > > > > --
> > > > > > > >
> > > > > > > > Thanks,
> > > > > > > > Pankaj Dubey
> > > > > > > >
> > > > > > > > > Regards
> > > > > > > > > Dong Aisheng
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > Thanks,
> > > > > > > > > > Pankaj Dubey
> > > > > > > > > >
> > > > > > > > > > > Regards
> > > > > > > > > > > Dong Aisheng
> > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > _______________________________________________
> > > > > > > > > > > > linux-arm-kernel mailing list
> > > > > > > > > > > > linux-arm-kernel@lists.infradead.org
> > > > > > > > > > > > http://lists.infradead.org/mailman/listinfo/linux-
> > > > > > > > > > > > arm-kernel
> > > > > > > > > >
> > > > > > > >
> > > > > >

