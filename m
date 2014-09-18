Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbaIRJi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:38:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37637 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbaIRJiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:38:24 -0400
X-AuditID: cbfee691-f79546d0000011a1-87-541aa80e51d8
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: Li.Xiubo@freescale.com, Aisheng.Dong@freescale.com
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, arnd@arndb.de, naushad@samsung.com,
        tomasz.figa@gmail.com, joshi@samsung.com, thomas.ab@samsung.com,
        vikas.sajjan@samsung.com, chow.kim@samsung.com, lee.jones@linaro.org,
        "'Boris BREZILLON'" <boris.brezillon@free-electrons.com>,
        "'Geert Uytterhoeven'" <geert+renesas@glider.be>,
        "'Stephen Warren'" <swarren@nvidia.com>
References: <1410935510-1567-1-git-send-email-pankaj.dubey@samsung.com>
 <20140917085818.GA10285@shlinux1.ap.freescale.net>
 <000401cfd269$922dfc40$b689f4c0$@samsung.com>
 <20140918030552.GA26661@shlinux1.ap.freescale.net>
 <000701cfd306$4d3e8080$e7bb8180$@samsung.com>
 <20140918075516.GB15363@shlinux1.ap.freescale.net>
 <1c762cb71a5245f19fdcec8266fd45b6@BY2PR0301MB0613.namprd03.prod.outlook.com>
In-reply-to: <1c762cb71a5245f19fdcec8266fd45b6@BY2PR0301MB0613.namprd03.prod.outlook.com>
Subject: RE: [PATCH v3] mfd: syscon: Decouple syscon interface from platform
 devices
Date: Thu, 18 Sep 2014 15:10:43 +0530
Message-id: <000d01cfd324$a2db05e0$e89111a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGAgvNtQpXjUZMClJmM9wWnjoVNAgMenyfbAIibLDoCPoOsEAI7E69pAJ14hxECRhVLU5xNH+rQ
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsWyRsSkTpdvhVSIwYGpahYLlr5lsfg76Ri7
	xYEXC1kslk26y2Yxd/YkRovvu76wW/QuuMpmcf/rUUaLzgsdrBabHl9jtbi8aw6bxYzz+5gs
	bl/mtfh09D+rxY3pLawWHcsYLVbt+sNocfPZdiYHIY+W5h42j9+/JjF6PNl0kdHj3+F+Jo+J
	Z3U9ds66y+5x59oeNo/NS+o9epvfsXn0bVnF6PF5k1wAdxSXTUpqTmZZapG+XQJXxoaOw2wF
	75UqpnWFNzBekupi5OSQEDCRWDhxIiOELSZx4d56NhBbSGApo8S92ZYwNf9+PmHqYuQCik9n
	lLh/AaQBxPkL5BzcBdbNJqAr8eT9XGYQW0TATKL/zSp2kCJmgXvMEhM/HWKD6JjKLLHrwR8W
	kCpOgWiJu+e/gnUIC4RJXO09zw5iswioSmx4f58VxOYVsJSYuPQIlC0o8WPyPbBeZgEtifU7
	jzNB2PISm9e8ZYa4VUFix9nXjBBXxEg8aj3HDFEjLjHpwUOwiyQE7nBIPDx3ixFimYDEt8mH
	gIZyACVkJTYdgJojKXFwxQ2WCYwSs5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kalecWJu
	cWleul5yfu4mRmCKOf3v2cQdjPcPWB9iFOBgVOLhlRCQChFiTSwrrsw9xGgKdNFEZinR5Hxg
	IssriTc0NjOyMDUxNTYytzRTEufVkf4ZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHRYBv/
	Mcu6vQGG2oH1dXtmVMfoNuxY/Pjb5iQ5kdWvLH8v3M9c3zir69yJ9LUVzodDrqy7qq4RdXP3
	bo8oj+aC15LaGTMUZix8x/D8880DqW5uLzdNW/rG+uDtEws2mSQXysVf8Um6uLe6yPK39pX9
	CY4v4zx9DYWDnaZwphbLM2udE2LKPsyjxFKckWioxVxUnAgA9gK8WSwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsVy+t9jQV2+FVIhBivPyFgsWPqWxeLvpGPs
	FgdeLGSxWDbpLpvF3NmTGC2+7/rCbtG74Cqbxf2vRxktOi90sFpsenyN1eLyrjlsFjPO72Oy
	uH2Z1+LT0f+sFjemt7BadCxjtFi16w+jxc1n25kchDxamnvYPH7/msTo8WTTRUaPf4f7mTwm
	ntX12DnrLrvHnWt72Dw2L6n36G1+x+bRt2UVo8fnTXIB3FENjDYZqYkpqUUKqXnJ+SmZeem2
	St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QI8pKZQl5pQChQISi4uV9O0wTQgNcdO1
	gGmM0PUNCYLrMTJAAwlrGDM2dBxmK3ivVDGtK7yB8ZJUFyMnh4SAicS/n0+YIGwxiQv31rN1
	MXJxCAlMZ5S4f2EiI4TzF8g5uIsRpIpNQFfiyfu5zCC2iICZRP+bVewgRcwC95glJn46BNU+
	lVli14M/LCBVnALREnfPfwXrEBYIk7jae54dxGYRUJXY8P4+K4jNK2ApMXHpEShbUOLH5Htg
	vcwCWhLrdx5ngrDlJTavecsMcauCxI6zrxkhroiReNR6jhmiRlxi0oOH7BMYhWYhGTULyahZ
	SEbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwCnsmvYNxVYPFIUYBDkYlHt4D
	vFIhQqyJZcWVuYcYJTiYlUR4fy0ECvGmJFZWpRblxxeV5qQWH2I0Bfp0IrOUaHI+ML3mlcQb
	GpuYmxqbWppYmJhZKonzHmy1DhQSSE8sSc1OTS1ILYLpY+LglGpgZGiceedMUbzcypX/e4+F
	u3Nac3sbGN227Qw1i9n379XmaceKkg59vLsvxPvidrUL1fzdy+37ja8eTV/+vUPXwfL89UJl
	mQWCSzfyH9bx6mfrfTzlx5I/B9vCr3czcax9ELHfeqbzlj+vFpc+kphRGpN5LrbpxOv9NR++
	6m0JibJfm5ynslAhTYmlOCPRUIu5qDgRAHIotE13AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On September 18, 2014, Li.Xiubo wrote,
> Subject: RE: [PATCH v3] mfd: syscon: Decouple syscon interface from
platform
> devices
> 
> [...]
> > > I think there should have been a check for NULL on "dev" in
> > > "regmap_get_val_endian", so that if dev pointer exist then only it
> > > makes sense to get endianness property from DT.
> > >
> > > I will suggest following fix in regmap.c for this. With following
> > > fix I tested it and it works well on linux-next also. So if you can
> > > confirm following fix is working for you then I can post this patch.
> > >
> >
> > I tested the patch work.
> > But as Xiubo pointed in another mail, it may still cause other issues.
> > Looking at regmap.c, there're still some other places using the device
> > pointer, e.g. dev_xxx debug information and some tracepoints also take
> > device pointer as parameter(not sure if it will break if dev is NULL).
> > Another thing is that if dev is NULL, we may not be able to use regmap
> > debugfs feature which seems also not as our expected.
> >
> > Maybe we could consider create device structure for each syscon
> > compatible device in syscon driver in of_syscon_register in first time
> > which seems to be reasonable.
> >
> > Regards
> > Dong Aisheng
> >
> > > --------------------------------------------
> > > Subject: [PATCH] regmap: fix NULL pointer dereference in
> > > regmap_get_val_endian
> > >
> > > Recent commits for getting reg endianess causing NULL pointer
> > > dereference if dev is passed NULL in regmap_init_mmio. This patch
> > > fixes this issue, and allows to parse reg endianess only if dev and
> > > dev->of_node exist.
> > >
> > > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > > ---
> > >  drivers/base/regmap/regmap.c |   23 ++++++++++++++---------
> > >  1 file changed, 14 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/base/regmap/regmap.c
> > > b/drivers/base/regmap/regmap.c index f2281af..455a877 100644
> > > --- a/drivers/base/regmap/regmap.c
> > > +++ b/drivers/base/regmap/regmap.c
> > > @@ -477,7 +477,7 @@ static enum regmap_endian
> > > regmap_get_val_endian(struct device *dev,
> > >  					const struct regmap_bus *bus,
> > >  					const struct regmap_config *config)
{
> > > -	struct device_node *np = dev->of_node;
> > > +	struct device_node *np;
> 
> And the 'np' must be NULL as default.
> 
> Isn't it ?
> 


Yes. 

Thanks,
Pankaj Dubey

> Thanks,
> 
> BRs
> Xiubo
> 
> > >  	enum regmap_endian endian;
> > >
> > >  	/* Retrieve the endianness specification from the regmap config */
> > > @@ -487,15 +487,20 @@ static enum regmap_endian
> > > regmap_get_val_endian(struct device *dev,
> > >  	if (endian != REGMAP_ENDIAN_DEFAULT)
> > >  		return endian;
> > >
> > > -	/* Parse the device's DT node for an endianness specification */
> > > -	if (of_property_read_bool(np, "big-endian"))
> > > -		endian = REGMAP_ENDIAN_BIG;
> > > -	else if (of_property_read_bool(np, "little-endian"))
> > > -		endian = REGMAP_ENDIAN_LITTLE;
> > > +	/* If the dev and dev->of_node exist try to get endianness from DT
> > > */
> > > +	if (dev && dev->of_node) {
> > > +		np = dev->of_node;
> > >
> > > -	/* If the endianness was specified in DT, use that */
> > > -	if (endian != REGMAP_ENDIAN_DEFAULT)
> > > -		return endian;
> > > +		/* Parse the device's DT node for an endianness
> > > specification */
> > > +		if (of_property_read_bool(np, "big-endian"))
> > > +			endian = REGMAP_ENDIAN_BIG;
> > > +		else if (of_property_read_bool(np, "little-endian"))
> > > +			endian = REGMAP_ENDIAN_LITTLE;
> > > +
> > > +		/* If the endianness was specified in DT, use that */
> > > +		if (endian != REGMAP_ENDIAN_DEFAULT)
> > > +			return endian;
> > > +	}
> > >
> > >  	/* Retrieve the endianness specification from the bus config */
> > >  	if (bus && bus->val_format_endian_default)
> > > --
> > >
> > > Thanks,
> > > Pankaj Dubey
> > >
> > > > Regards
> > > > Dong Aisheng
> > > >
> > > > >
> > > > > Thanks,
> > > > > Pankaj Dubey
> > > > >
> > > > > > Regards
> > > > > > Dong Aisheng
> > > > > >
> > > > > > >
> > > > > > >
> > > > > > > _______________________________________________
> > > > > > > linux-arm-kernel mailing list
> > > > > > > linux-arm-kernel@lists.infradead.org
> > > > > > > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> > > > >
> > >

