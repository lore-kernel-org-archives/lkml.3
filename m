Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaIZE5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:57:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20604 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaIZE51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:57:27 -0400
X-AuditID: cbfee691-f79b86d000004a5a-53-5424f22ed4c8
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "=?iso-8859-1?Q?'Heiko_St=FCbner'?=" <heiko@sntech.de>,
        "'Joachim Eastwood'" <manabian@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>, naushad@samsung.com,
        b29396@freescale.com, tomasz.figa@gmail.com, joshi@samsung.com,
        thomas.ab@samsung.com, Li.Xiubo@freescale.com,
        vikas.sajjan@samsung.com, chow.kim@samsung.com, lee.jones@linaro.org,
        dianders@chromium.org
References: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com>
 <CAGhQ9VzZ8LadDT5RWUSX89q0WP3fGiQ8f=bWbRVfEz5Vy_zZKw@mail.gmail.com>
 <13449286.k3JCbR2ABy@phil> <4389453.TP96FZcCbx@phil>
In-reply-to: <4389453.TP96FZcCbx@phil>
Subject: RE: [PATCH v5] mfd: syscon: Decouple syscon interface from platform
 devices
Date: Fri, 26 Sep 2014 10:26:35 +0530
Message-id: <000d01cfd946$521304f0$f6390ed0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKkPpk+xGsfKb8cRzoLv6q27vvt4QLpsJPoAdTrK9IBn/p/P5o3DC1g
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsWyRsSkSlfvk0qIwY43RhZ/Jx1jt3i4s5/F
	Ytmku2wWZ5cdZLP4/+g1q8X3XV/YLXoXXGWzuP/1KKNF54UOVotNj6+xWlzeNYfNYsb5fUwW
	ty/zWuy+fo7R4tPR/6wWHcsYLVbt+sNocfPZdiYHIY+W5h42j9+/JjF6zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvUffllWMHtuvzWP2+LxJLoArissmJTUnsyy1SN8ugStjw/1PLAU7rCta
	351jamCcpdfFyMEhIWAi8exNWRcjJ5ApJnHh3nq2LkYuDiGBpYwSHVceM0MkTCQaH01jhEhM
	Z5S4MfckM4Tzl1Fixaz7YFVsAroST97PBbNFBJIltsyYzgRSxCxwmFli8qI37BAdRxkl3pyf
	BVbFKaAm8e7lDEYQW1ggTOLPoWYmEJtFQFXiyNKZrCA2r4ClxMy2I+wQtqDEj8n3WEBsZgEd
	id7v35ghbG2JJ+8usELcqiCx4+xrRogr3CSu71nABlEjLjHpwUOwIyQE7nBI/JoxmxFimYDE
	t8mHWCCBISux6QDUz5ISB1fcYJnAKDELyepZSFbPQrJ6FpIVCxhZVjGKphYkFxQnpReZ6hUn
	5haX5qXrJefnbmIEJpfT/55N3MF4/4D1IUYBDkYlHt7GNSohQqyJZcWVuYcYTYEumsgsJZqc
	D0xheSXxhsZmRhamJqbGRuaWZkrivDrSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MF6Q
	vHfJ6PSbKbnrL4mvq7dcUnkk/SNP0p8yRWeRD8bt4lseC1yfKvKs/niYcO/TD1x3dTcvW1gh
	PE3nchNLu0bzgYwP+WvXvZskYLqWL/Fy4Jp7pewzRE7WbH198G6tj+JshaJNtSbqrTLt7L2P
	GvndbX/M/pO7TsP996dH125I6r6d56z1J0yJpTgj0VCLuag4EQCOzSEHKQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jQV29TyohBjMva1j8nXSM3eLhzn4W
	i2WT7rJZnF12kM3i/6PXrBbfd31ht+hdcJXN4v7Xo4wWnRc6WC02Pb7GanF51xw2ixnn9zFZ
	3L7Ma7H7+jlGi09H/7NadCxjtFi16w+jxc1n25kchDxamnvYPH7/msToMbvhIovHv8P9TB47
	Z91l97hzbQ+bx+Yl9R59W1Yxemy/No/Z4/MmuQCuqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B4
	53hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygp5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo
	+oYEwfUYGaCBhDWMGRvuf2Ip2GFd0fruHFMD4yy9LkZODgkBE4nGR9MYIWwxiQv31rN1MXJx
	CAlMZ5S4MfckM4Tzl1Fixaz7zCBVbAK6Ek/ezwWzRQSSJbbMmM4EUsQscJhZYvKiN+wQHUcZ
	Jd6cnwVWxSmgJvHu5QywHcICYRJ/DjUzgdgsAqoSR5bOZAWxeQUsJWa2HWGHsAUlfky+xwJi
	MwvoSPR+/8YMYWtLPHl3gRXiVgWJHWdfM0Jc4SZxfc8CNogacYlJDx6yT2AUmoVk1Cwko2Yh
	GTULScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHJ65nUDsaVDRaHGAU4GJV4eG+s
	UwkRYk0sK67MPcQowcGsJMIb+QYoxJuSWFmVWpQfX1Sak1p8iNEU6NOJzFKiyfnAxJpXEm9o
	bGJuamxqaWJhYmapJM57oNU6UEggPbEkNTs1tSC1CKaPiYNTqoGRz0jqXsKUXSLH0jYvlZUL
	uChQtsNRaLvjbJ1bz6zCOo5vlp1Yv0xOb/7SzgdHp52Uj1yrUbdIi1ukvPN9fePzBwrnQ+z7
	ZqlbP7ye+y26wZyf1ee4+OUAecYzfkw6WkpyOev+zls275657Z2WjoOXz+7o1f8tftdoz/b+
	//7HX4mbBB7ce55NiaU4I9FQi7moOBEAAzzB0HQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko and Joachim,

> -----Original Message-----
> From: Heiko Stübner [mailto:heiko@sntech.de]
> Sent: Thursday, September 25, 2014 5:52 PM
> To: Pankaj Dubey
> Cc: Joachim Eastwood; linux-arm-kernel@lists.infradead.org; linux-samsung-
> soc@vger.kernel.org; linux-kernel@vger.kernel.org; kgene.kim@samsung.com;
> Russell King - ARM Linux; Arnd Bergmann; naushad@samsung.com;
> b29396@freescale.com; tomasz.figa@gmail.com; joshi@samsung.com;
> thomas.ab@samsung.com; Li.Xiubo@freescale.com; vikas.sajjan@samsung.com;
> chow.kim@samsung.com; lee.jones@linaro.org; dianders@chromium.org
> Subject: Re: [PATCH v5] mfd: syscon: Decouple syscon interface from
platform
> devices
> 
> Am Mittwoch, 24. September 2014, 20:35:10 schrieb Heiko Stübner:
> > Hi Pankaj, Joachim,
> >
> > Am Dienstag, 23. September 2014, 20:12:50 schrieb Joachim Eastwood:
> > > On 22 September 2014 06:40, Pankaj Dubey <pankaj.dubey@samsung.com>
> wrote:
> > > > Currently a syscon entity can be only registered directly through
> > > > a platform device that binds to a dedicated syscon driver. However
> > > > in certain use cases it is desirable to make a device used with
> > > > another driver a syscon interface provider.
> > > >
> > > > For example, certain SoCs (e.g. Exynos) contain system controller
> > > > blocks which perform various functions such as power domain
> > > > control, CPU power management, low power mode control, but in
> > > > addition contain certain IP integration glue, such as various
> > > > signal masks, coprocessor power control, etc. In such case, there
> > > > is a need to have a dedicated driver for such system controller
> > > > but also share registers with other drivers. The latter is where the
syscon
> interface is helpful.
> > > >
> > > > In case of DT based platforms, this patch decouples syscon object
> > > > from syscon platform driver, and allows to create syscon objects
> > > > first time when it is required by calling of
> > > > syscon_regmap_lookup_by APIs and keep a list of such syscon
> > > > objects along with syscon provider device_nodes and regmap handles.
> > > >
> > > > For non-DT based platforms, this patch keeps syscon platform
> > > > driver structure where is can be probed and such non-DT based
> > > > drivers can use syscon_regmap_lookup_by_pdev API and get access to
> regmap handles.
> > > > Once all users of "syscon_regmap_lookup_by_pdev" migrated to DT
> > > > based, we can completly remove platform driver of syscon, and keep
> > > > only helper functions to get regmap handles.
> > > >
> > > > Suggested-by: Arnd Bergmann <arnd@arndb.de>
> > > > Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
> > > > Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> > > > Tested-by: Javier Martinez Canillas
> > > > <javier.martinez@collabora.co.uk>
> > > > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > >
> > > I wrote a clk driver using syscon and your patch. clk driver uses
> > > CLK_OF_DECLARE, btw.
> > >
> > > It works but I get a '(null): Failed to create debugfs directory'
> > > message in the boot log.
> > >
> > > Tested-by: Joachim Eastwood <manabian@gmail.com>
> >
> > on Rockchip platforms this syscon support also helps quite a bit, as
> > the pll lock-status is sitting in an external syscon register, so
> > setting target pll-rates through assigned-clocks is not easily doable
without it.
> > Therefore I'm very much looking forward to this.
> >
> >
> > Similar to Joachim I get an error about debugfs from regmap, which
> > seems to be caused by
> > 	name = dev_name(map->dev);
> > returning NULL in regmap_debugfs_init in regmap-debugfs.c for such an
> > "early" syscon.
> 
> It looks like of_device_make_bus_id would be able to do the necessary
steps to
> populate the dev_name seemingly correctly.
> 
> With the diff below I now get a syscon that can init clocks and also a
sane regmap
> debugfs init:
> 
> /debug/regmap # ls -la
> total 0
> drwxr-xr-x    5 0        0                0 Jan  1  1970 .
> drwx------   19 0        0                0 Jan  1  1970 ..
> drwxr-xr-x    2 0        0                0 Jan  1  1970 0-001b
> drwxr-xr-x    2 0        0                0 Jan  1  1970
ff730000.power-management
> drwxr-xr-x    2 0        0                0 Jan  1  1970 ff770000.syscon
> 
> 
> But of course I don't know enough about device-internals to determine if
this is an
> insane solution or not :-)
> 

Thanks Heiko for figuring out issue and proposed solution.

As you and Joachim pointed out that current patch failed to create regmap
debugfs entry,
I also investigated and found that it fails to create regmap debugfs entry
either you call it
early (from init_irq or clk_init function) or you call it in later stage
before actual device is
populated (from init_machine before of_platform_populate_device).

One point is regmap debugfs code should have handled it gracefully instead
of kernel panic,
so looks like it needs some fix in that part of code.

I tried Heiko's suggested solution of calling "of_device_make_bus_id" after
platform_device_alloc
and it worked well and I tested it from init_irq as well as clk_init, which
happens at very early stage.
Maybe Joachim can also try if it's working for him.

Only concerns for this approach: Is it proper way of doing this?

In my opinion it could be, if we are not getting any other approach of
handling early syscon.

I also tried to get any other solution for handling debugfs entry, and found
one more solution.
But it will work only for late users of syscon: 

pdev = platform_device_alloc("dummy-syscon", -1);
ret = platform_device_add(pdev);

It can solve issue of regmap debugfs for late users, i.e. if we try to use
syscon_lookup_by APIs not before
init_machine. But this will not work for early users of syscon, as I can see
that "platform_device_add"
fails (kernel panic) if we call it from init_irq or clk_init.

Meanwhile I have posted a fix [1] for this so that if someone calls
platform_device_add at very early
stage at least it should not panic and kernel should handle it gracefully. 

[1]: https://lkml.org/lkml/2014/9/24/348

Also as I mentioned earlier, providing feature of early syscon availability
was not the main objective of this
patch, so just to make sure that this should not be a blocking factor for
current patch I would like to split
patch in two steps to address to different issues:

1: First patch will cover existing users and allow any such users to create
actual platform device and register
their own platform driver, instead of syscon getting probed first.
I will make sure that it should not break existing users or any existing
functionality (including debugfs).

2: Second on top of this patch we can have discussion how to go for early
syscon users.

Thanks,
Pankaj Dubey
> 
> Heiko
> 
> 
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c index
8ebc1c6..3734434
> 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -73,6 +73,7 @@ static struct syscon *of_syscon_register(struct
device_node
> *np)
>                         goto err_pdev;
>                 }
>                 pdev->dev.of_node = of_node_get(np);
> +               of_device_make_bus_id(&pdev->dev);
>         }
> 
>         regmap = devm_regmap_init_mmio(&pdev->dev, base,
> &syscon_regmap_config);

