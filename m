Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaIDEhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 00:37:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43554 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaIDEhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 00:37:18 -0400
X-AuditID: cbfee68d-f79c46d000000b84-30-5407ec7babcb
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        kgene.kim@samsung.com, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com, tomasz.figa@gmail.com,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Alexander Shiyan'" <shc_work@mail.ru>,
        "'Michal Simek'" <michal.simek@xilinx.com>
References: <1409668935-10667-1-git-send-email-pankaj.dubey@samsung.com>
 <6034841.GFrG3XCMdb@wuerfel>
In-reply-to: <6034841.GFrG3XCMdb@wuerfel>
Subject: RE: [PATCH v2] mfd: syscon: Decouple syscon interface from platform
 devices
Date: Thu, 04 Sep 2014 10:09:19 +0530
Message-id: <002601cfc7fa$39413580$abc3a080$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIt001XuICEdFXqks+cH6c/XVPcogHeMPhCmyVSLjA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsWyRsSkSrf6DXuIweMueYu/k46xWyybdJfN
	4vuuL+wWvQuuslnc/3qU0WLT42usFpd3zWGzmHF+H5PF7cu8Fu9eRlh8Ovqf1WLSDimLjmWM
	Fqt2/WG0uPlsO5MDv0dLcw+bx+9fkxg9ds66y+5x59oeNo/NS+o9psw9wurRt2UVo8fnTXIe
	ez//ZgngjOKySUnNySxLLdK3S+DKWPzsP3vBK72Kw89sGxivq3YxcnBICJhI/PmQ28XICWSK
	SVy4t56ti5GLQ0hgKaPEoTlrWWBqjv6rhYgvYpT4/mcCO4Tzl1HizLEuJpBuNgFdiSfv5zKD
	2CICyhLHX95hASliFtjMLLF9/QFGkISQQLrE5+adrCA2p4CmxI0jT1hAbGGBMIlZj5vAbBYB
	VYlfUxeD1fMKWErc2v+JCcIWlPgx+R5YDbOAlsT6nceZIGx5ic1r3jJDvKAgsePsa0aII6wk
	7vV+YoeoEZeY9OAh2NUSAns4JP6f2McKsUxA4tvkQ1BvykpsOgA1R1Li4IobLBMYJWYhWT0L
	yepZSFbPQrJiASPLKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYzAVHH637PeHYy3D1gfYhTg
	YFTi4S14wR4ixJpYVlyZe4jRFOiiicxSosn5wISUVxJvaGxmZGFqYmpsZG5ppiTOqyj1MxgY
	iIklqdmpqQWpRfFFpTmpxYcYmTg4pRoYg0yDuqa+0Ao80nMvNCdMfePe4OKjqbJK3ewzzjwt
	dWY5tmFzXl+k9fSNqWsT/3I1Nb/I/Xbex+TRuo7nrg8WPOG7/k39+FGV1JJ9C5d2CawzbFfc
	Lb7G5uTjm2Y/Jxvr3dne9FdOo3LFo59+Z24aufzO2f8vyjikMW1iW5ykgHDzrl+KDNcfKLEU
	ZyQaajEXFScCAJag31gQAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jAd3qN+whBn82i1j8nXSM3WLZpLts
	Ft93fWG36F1wlc3i/tejjBabHl9jtbi8aw6bxYzz+5gsbl/mtXj3MsLi09H/rBaTdkhZdCxj
	tFi16w+jxc1n25kc+D1amnvYPH7/msTosXPWXXaPO9f2sHlsXlLvMWXuEVaPvi2rGD0+b5Lz
	2Pv5N0sAZ1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4Cu
	W2YO0PlKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxozFz/6zF7zSqzj8
	zLaB8bpqFyMHh4SAicTRf7VdjJxAppjEhXvr2boYuTiEBBYxSnz/M4EdwvnLKHHmWBcTSBWb
	gK7Ek/dzmUFsEQFlieMv77CAFDELbGaW2L7+ACNIQkggXeJz805WEJtTQFPixpEnLCC2sECY
	xKzHTWA2i4CqxK+pi8HqeQUsJW7t/8QEYQtK/Jh8D6yGWUBLYv3O40wQtrzE5jVvmSFOVZDY
	cfY1I8QRVhL3ej+xQ9SIS0x68JB9AqPQLCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdIr
	TswtLs1L10vOz93ECE5Fz6R3MK5qsDjEKMDBqMTDW/CCPUSINbGsuDL3EKMEB7OSCO/ss0Ah
	3pTEyqrUovz4otKc1OJDjKZAn05klhJNzgemybySeENjE3NTY1NLEwsTM0slcd6DrdaBwPBK
	LEnNTk0tSC2C6WPi4JRqYIxg2uzirl4y/8bnOdf8L7Vu/MLvs7Ccq/bP9HW/Ete99LmQlfP4
	kVZfp3YVm26JJ/NEAa6rVcqVB+auyDgfus7l5xVzpXkLos5o5q387HP+zkXhpipZC//PKg9e
	eKsbTTzzKjbD6cCjhpudrH0LC+QVTFkXKF9Qalx3N/jEmfhrbZ9Uq9njuZRYijMSDbWYi4oT
	AQUMin9bAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tuesday, September 02, 2014 Arnd Bergmann wrote,
> To: Pankaj Dubey
> Cc: linux-arm-kernel@lists.infradead.org;
linux-samsung-soc@vger.kernel.org; linux-
> kernel@vger.kernel.org; lee.jones@linaro.org; kgene.kim@samsung.com;
> linux@arm.linux.org.uk; vikas.sajjan@samsung.com; joshi@samsung.com;
> naushad@samsung.com; thomas.ab@samsung.com; chow.kim@samsung.com;
> tomasz.figa@gmail.com; Tomasz Figa; Alexander Shiyan; Michal Simek
> Subject: Re: [PATCH v2] mfd: syscon: Decouple syscon interface from
platform
> devices
> 
> On Tuesday 02 September 2014 20:12:15 Pankaj Dubey wrote:
> > Currently a syscon entity can only be registered directly through a
> > platform device that binds to a dedicated syscon driver. However in
> > certain cases it is required to bind a device with it's dedicated
> > driver rather than binding with syscon driver.
> >
> > For example, certain SoCs (e.g. Exynos) contain system controller
> > blocks which perform various functions such as power domain control,
> > CPU power management, low power mode control, but in addition contain
> > certain IP integration glue, such as various signal masks, coprocessor
> > power control, etc. In such case, there is a need to have a dedicated
> > driver for such system controller but also share registers with other
> > drivers. The latter is where the syscon interface is helpful.
> >
> > This patch decouples syscon object from syscon platform driver, and
> > allows to create syscon objects first time when it is required by
> > calling of syscon_regmap_lookup_by APIs and keeps a list of such
> > syscon objects along with syscon provider device_nodes and regmap
handles.
> >
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> > ---
> > V1 of this patchset [1] and related discussion can be found here [1].
> >
> > Changes since v1:
> >  - Removed of_syscon_unregister function.
> >  - Modified of_syscon_register function and it will be used by syscon.c
> >    to create syscon objects whenever required.
> >  - Removed platform device support from syscon.
> >  - Removed syscon_regmap_lookup_by_pdevname API support.
> >  - As there are significant changes w.r.t patchset v1, I am taking over
> >    author for this patchset from Tomasz Figa.
> 
> Note that you got the Signed-off-by: list wrong, you should never have any
people
> listed as Signed-off-by after your own name, and they should be listed
before your
> name only when you are forwarding their patches.
> 

Sorry, I was not aware of this. I will take care in future.

> > Note: Current kernel has clps711x user of
> > syscon_regmap_lookup_by_pdevname and will be broken after this patch.
> > As per discussion over here [1], patches for making these drivers DT
> > based are ready and once that is done they can use
> syscon_regmap_lookup_by_phandle or syscon_regmap_lookup_by_compatible.
> >
> > [1]: https://lkml.org/lkml/2014/8/22/81
> 
> Adding Alexander Shiyan to Cc here, so we can make sure this is well
coordinated.
> 
> I'm also adding Michal Simek, since here was involved in earlier
discussions about
> doing this.
> 

Thanks.

> >  drivers/mfd/syscon.c       |  143
+++++++++++++-------------------------------
> >  include/linux/mfd/syscon.h |    1 +
> >  2 files changed, 44 insertions(+), 100 deletions(-)
> 
> I certainly like the diffstat ;-)
> 
> >  struct syscon {
> > +	struct device_node *np;
> >  	struct regmap *regmap;
> > +	struct list_head list;
> >  };
> 
> Right
> 
> > @@ -68,27 +72,6 @@ struct regmap
> > *syscon_regmap_lookup_by_compatible(const char *s)  }
> > EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
> >
> > -static int syscon_match_pdevname(struct device *dev, void *data) -{
> > -	return !strcmp(dev_name(dev), (const char *)data);
> > -}
> > -
> > -struct regmap *syscon_regmap_lookup_by_pdevname(const char *s) -{
> > -	struct device *dev;
> > -	struct syscon *syscon;
> > -
> > -	dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> > -				 syscon_match_pdevname);
> > -	if (!dev)
> > -		return ERR_PTR(-EPROBE_DEFER);
> > -
> > -	syscon = dev_get_drvdata(dev);
> > -
> > -	return syscon->regmap;
> > -}
> > -EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);
> 
> I think this can actually be left intact if that helps with clps71xx.
> It could be done in a hacky way using bus_find_device_by_name() to keep it
simple,
> or in a somewhat nicer way by keeping the syscon platform_driver around
for the
> non-DT case.
> 

Ok as per our last discussion you mentioned that clps71xx will be soon
migrating to DT.
So if that is not going to happen sooner, I would also prefer better keep
syscon_regmap_lookup_by_pdevname and syscon platform_driver for non-DT case,
so that this issue should not block this patch.

So please let's make final call to keep syscon platform_driver for non-DT
case which eventually
can be dropped once clps71xx driver migrates to DT based. So that I can
prepare next patchset
keeping syscon platform_driver support  and syscon_regmap_lookup_by_pdevname
API support
for non-DT case and send across for review. 


> 
> > +	regmap = regmap_init_mmio(NULL, base, &syscon_regmap_config);
> > +	if (IS_ERR(regmap)) {
> > +		pr_err("regmap init failed\n");
> > +		return ERR_CAST(regmap);
> > +	}
> 
> The last time I looked over this code, I think it was not safe to
> call regmap_init_mmio() with a NULL device pointer, and we decided
> that should be fixed. Have you checked whether it is ok now?
> 

At least we could not see any issues with this. We have tested it one
Exynos5250 board
where syscon object is getting created first time when other drivers (USB,
SATA Phy, Watchdog)
are calling helper function syscon_regmap_lookup_by_phandle and able to
access regmap handle
and able to use regmap_read/write APIs.

> 	Arnd

