Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbaIRGBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 02:01:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34034 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaIRGBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 02:01:16 -0400
X-AuditID: cbfee68d-f79c46d000000b84-e9-541a75291285
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Dong Aisheng'" <b29396@freescale.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, arnd@arndb.de, naushad@samsung.com,
        tomasz.figa@gmail.com, joshi@samsung.com, thomas.ab@samsung.com,
        vikas.sajjan@samsung.com, chow.kim@samsung.com, lee.jones@linaro.org,
        "'Boris BREZILLON'" <boris.brezillon@free-electrons.com>,
        "'Xiubo Li'" <Li.Xiubo@freescale.com>,
        "'Geert Uytterhoeven'" <geert+renesas@glider.be>,
        "'Stephen Warren'" <swarren@nvidia.com>
References: <1410935510-1567-1-git-send-email-pankaj.dubey@samsung.com>
 <20140917085818.GA10285@shlinux1.ap.freescale.net>
 <000401cfd269$922dfc40$b689f4c0$@samsung.com>
 <20140918030552.GA26661@shlinux1.ap.freescale.net>
In-reply-to: <20140918030552.GA26661@shlinux1.ap.freescale.net>
Subject: RE: [PATCH v3] mfd: syscon: Decouple syscon interface from platform
 devices
Date: Thu, 18 Sep 2014 11:33:26 +0530
Message-id: <000701cfd306$4d3e8080$e7bb8180$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGAgvNtQpXjUZMClJmM9wWnjoVNAgMenyfbAIibLDoCPoOsEJx1zwVQ
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsWyRsSkRlezVCrE4OU6BYu/k46xWzzc2c9i
	ceDFQhaLZZPuslnMnT2J0eL7ri/sFr0LrrJZ3P96lNGi80IHq8Wmx9dYLS7vmsNmMeP8PiaL
	25d5LT4d/c9qcWN6C6tFxzJGi1W7/jBa3Hy2nclByKOluYfN4/evSYweTzZdZPT4d7ifyWPi
	WV2PnbPusnvcubaHzWPzknqP3uZ3bB59W1YxenzeJBfAHcVlk5Kak1mWWqRvl8CV8WDaVdaC
	1eoVMw60sjcwtsp3MXJySAiYSDzsP8oGYYtJXLi3HswWEljKKLF4i38XIwdEzaH4LkYuoPB0
	RomHS14wQjh/GSVmTdvOCNLAJqAr8eT9XGYQW0RAU+L5ntesIEXMAq0sEk9b17BBdDxklDh5
	ewULSBWngL3EhvWXmEBsYYEwiau959lB1rEIqEqc3lELEuYVsJRYsPMfI4QtKPFj8j2wVmYB
	LYn1O48zQdjyEpvXvGWG+EBBYsfZ14wQR7hJPG35zwhRIy4x6cFDdpAbJAQecEjcez0RLMEi
	ICDxbfIhFog3ZSU2HYCaIylxcMUNlglA/yFZPQvJ6llIVs9CsmIBI8sqRtHUguSC4qT0IkO9
	4sTc4tK8dL3k/NxNjMAEc/rfs94djLcPWB9iFOBgVOLhPcArFSLEmlhWXJl7iNEU6KKJzFKi
	yfnANJZXEm9obGZkYWpiamxkbmmmJM6rKPUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj
	sSL/+vDXvHqJ/V6ix2uSPPk6/8t/kv7Se1ner5nt6ifvNX+nxPe+fqa8slh0woc9TRa6Sq3r
	02eYWiwJ/mrx6wTzE59r5l7xqbZ9R7YnrfZjF2RNMr0SdDQlufccqw4Hc+eHpHNn1m05/C6i
	e7mB3EwDg5e6b/axv9IJ5nMSddoo/fOzUZYSS3FGoqEWc1FxIgDhcktdKwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jQV3NUqkQg74nYhZ/Jx1jt3i4s5/F
	4sCLhSwWyybdZbOYO3sSo8X3XV/YLXoXXGWzuP/1KKNF54UOVotNj6+xWlzeNYfNYsb5fUwW
	ty/zWnw6+p/V4sb0FlaLjmWMFqt2/WG0uPlsO5ODkEdLcw+bx+9fkxg9nmy6yOjx73A/k8fE
	s7oeO2fdZfe4c20Pm8fmJfUevc3v2Dz6tqxi9Pi8SS6AO6qB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6DElhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGENY8aDaVdZC1arV8w40MrewNgq38XIwSEhYCLx8FB8FyMnkCkmceHe
	erYuRi4OIYHpjBIPl7xghHD+MkrMmradEaSKTUBX4sn7ucwgtoiApsTzPa9ZQYqYBVpZJJ62
	roFqf8gocfL2ChaQKk4Be4kN6y8xgdjCAmESV3vPs4OsZhFQlTi9oxYkzCtgKbFg5z9GCFtQ
	4sfke2CtzAJaEut3HmeCsOUlNq95ywxxqoLEjrOvGSGOcJN42vKfEaJGXGLSg4fsExiFZiEZ
	NQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnACeya1g3Flg8UhRgEO
	RiUe3gO8UiFCrIllxZW5hxglOJiVRHjzfIFCvCmJlVWpRfnxRaU5qcWHGE2BHp3ILCWanA9M
	rnkl8YbGJuamxqaWJhYmZpZK4rwHWq0DhQTSE0tSs1NTC1KLYPqYODilGhj7v7IxVNS9tZ3H
	FzzBRbzlmKyF86FVfPxvyw1P65VnLy+wPtRmKyvFYJO376/TgYUXyn70O11xMlEpt24MzVfJ
	Vr4rl1z37tP7ll7FaY8sszUu11Yrn1nnJFbcfOrLssIdu9znHzK6a27DrsfOYJcg9Xz7sTdn
	2Ct0++2mLpZ8r7i8/e8bKSWW4oxEQy3mouJEAGUPAip2AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Adding CC to Xiubo Li, Geert Uytterhoeven and Stephen Warren. 

On Thursday, September 18, 2014, Dong Aisheng wrote,
> On Wed, Sep 17, 2014 at 04:50:50PM +0530, Pankaj Dubey wrote:
> > Hi,
> >
> > On Wednesday, September 17, 2014, Dong Aisheng Wrote,
> > > >
> > > > +	regmap = regmap_init_mmio(NULL, base,
&syscon_regmap_config);
> > >
> > > Does a NULL device pointer work?
> >
> > Yes, it is safe, at least we are able to test on Exynos based SoC.
> > I have tested it with kgene/for-next kernel on Exynos3250.
> > Also it has been tested on Exynos5250 based Snow board with 3.17-rc5
> > based kernel by Vivek Gautam.
> >
> > Patch V2 also has been tested by "Borris Brezillon" on AT91 platform.
> >
> >
> 
> The kernel i tested was next-20140915 of linux-next.
> 
> please see regmap_get_val_endian called in regmap_init function.
> static enum regmap_endian regmap_get_val_endian(struct device *dev,
>                                         const struct regmap_bus *bus,
>                                         const struct regmap_config
*config) {
>         struct device_node *np = dev->of_node;
>         enum regmap_endian endian;
> ...
> }
> It will crash at the first line of dev->of_node if dev is NULL.
> 
> Can you check if you're using the same code as mine?

No, it's not same.
My bad that I was not using linux-next for testing this patch.
We tested on kgene/for-next where these changes still have not come.
Just now I checked linux-next and found that it will crash at first line of 
"regmap_get_val_endian" as there is no check for NULL on dev.

I checked git history of regmap.c file and found recently this file has been
modified
for adding DT endianness binding support. Following are set of patches gone
for this

cf673fb regmap: Split regmap_get_endian() in two functions
5844a8b regmap: Fix handling of volatile registers for format_write() chips
45e1a27 regmap: of_regmap_get_endian() cleanup
ba1b53f regmap: Fix DT endianess parsing logic
d647c19 regmap: add DT endianness binding support.

I think there should have been a check for NULL on "dev" in
"regmap_get_val_endian", so that if dev pointer exist then only it makes
sense to get
endianness property from DT. 

I will suggest following fix in regmap.c for this. With following fix I
tested it and it works well
on linux-next also. So if you can confirm following fix is working for you
then I can post this
patch.

--------------------------------------------
Subject: [PATCH] regmap: fix NULL pointer dereference in
 regmap_get_val_endian

Recent commits for getting reg endianess causing NULL pointer
dereference if dev is passed NULL in regmap_init_mmio. This patch
fixes this issue, and allows to parse reg endianess only if dev
and dev->of_node exist.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/base/regmap/regmap.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index f2281af..455a877 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -477,7 +477,7 @@ static enum regmap_endian regmap_get_val_endian(struct
device *dev,
 					const struct regmap_bus *bus,
 					const struct regmap_config *config)
 {
-	struct device_node *np = dev->of_node;
+	struct device_node *np;
 	enum regmap_endian endian;
 
 	/* Retrieve the endianness specification from the regmap config */
@@ -487,15 +487,20 @@ static enum regmap_endian regmap_get_val_endian(struct
device *dev,
 	if (endian != REGMAP_ENDIAN_DEFAULT)
 		return endian;
 
-	/* Parse the device's DT node for an endianness specification */
-	if (of_property_read_bool(np, "big-endian"))
-		endian = REGMAP_ENDIAN_BIG;
-	else if (of_property_read_bool(np, "little-endian"))
-		endian = REGMAP_ENDIAN_LITTLE;
+	/* If the dev and dev->of_node exist try to get endianness from DT
*/
+	if (dev && dev->of_node) {
+		np = dev->of_node;
 
-	/* If the endianness was specified in DT, use that */
-	if (endian != REGMAP_ENDIAN_DEFAULT)
-		return endian;
+		/* Parse the device's DT node for an endianness
specification */
+		if (of_property_read_bool(np, "big-endian"))
+			endian = REGMAP_ENDIAN_BIG;
+		else if (of_property_read_bool(np, "little-endian"))
+			endian = REGMAP_ENDIAN_LITTLE;
+
+		/* If the endianness was specified in DT, use that */
+		if (endian != REGMAP_ENDIAN_DEFAULT)
+			return endian;
+	}
 
 	/* Retrieve the endianness specification from the bus config */
 	if (bus && bus->val_format_endian_default)
--

Thanks,
Pankaj Dubey

> Regards
> Dong Aisheng
> 
> >
> > Thanks,
> > Pankaj Dubey
> >
> > > Regards
> > > Dong Aisheng
> > >
> > > >
> > > >
> > > > _______________________________________________
> > > > linux-arm-kernel mailing list
> > > > linux-arm-kernel@lists.infradead.org
> > > > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> >

