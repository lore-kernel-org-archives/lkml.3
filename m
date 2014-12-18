Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaLRGYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:24:32 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:61350 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaLRGYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:24:30 -0500
X-AuditID: cbfee691-f79b86d000004a5a-89-5492731bf2f8
Date: Thu, 18 Dec 2014 06:24:27 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCHv4 1/8] devfreq: event: Add new devfreq_event class to
 provide basic data for devfreq governor
To: =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>
Cc: =?utf-8?Q?=EA=B9=80=EA=B5=AD=EC=A7=84?= <kgene.kim@samsung.com>,
        =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        =?utf-8?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20141218055005400@myungjoo.ham
Msgkey: 20141218055005400@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141218055005400@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1527528755.303581418883865069.JavaMail.weblogic@epmlwas01d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkRFe6eFKIweZlYhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSujqeUha8EE+4rnH2axNDDuse1i5OQQElCXWLTkJBuILSFgIrH7
	6TdmCFtM4sK99UBxLqCapYwSzVefwxXNP9nOCtE8h1Hie1c6iM0ioCqxZtla9i5GDg42AT2J
	mZ+TQcLCAoUSi3bcBpspIuAqsXLtIhaQmcwCy9kkHk5/wgwxR0lizb5XLCA2r4CgxMmZT1gg
	dqlKbL5yiwkiriZxc20/1A3iEhfmXmKHsHklZrQ/haqXk5j2dQ3UA9IS52dtYIR5ZvH3x1Bx
	foljt3cwQdgCElPPHISq0ZL4/H0n1Bw+iTUL37LA1O86tZwZZtf9LXOheiUktrY8AYcDs4Ci
	xJTuh2C/MwtoSqzfpY/uFV4BD4m/DR2MIL9LCEzlkNjy7gHbBEalWUjqZiEZNQthFLKSBYws
	qxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzEC08Lpf88m7mC8f8D6EKMAB6MSD6+E3qQQIdbE
	suLK3EOMpsBYmsgsJZqcD0w+eSXxhsZmRhamJqbGRuaWZkrivDrSP4OFBNITS1KzU1MLUovi
	i0pzUosPMTJxcEo1MO4IMDxayfXpBms08/4C14mxM/bP7+mprto3I27a3QML5kQvDbhnH/JO
	eOfy6/2yrjJGAc+nZd+fWnnF3Wg734kzky/vUdLaP3P59NMzTi6rXmY+fZXcivid0kfj3rAE
	XDX7s6DsiLHvuvtidRci45XUbXxWL7zG2bKwcYnm7a0fDZ+znD/IXyCkxFKckWioxVxUnAgA
	Zy3OCwYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t/tPl3p4kkhBnc28llc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIym
	loesBRPsK55/mMXSwLjHtouRk0NIQF1i0ZKTbCC2hICJxPyT7awQtpjEhXvr2SBq5jBKfO9K
	B7FZBFQl1ixby97FyMHBJqAnMfNzMkhYWKBQYtGO28wgtoiAq8TKtYtYuhi5OJgFlrNJPJz+
	hBlijpLEmn2vWEBsXgFBiZMzn7BA7FKV2HzlFhNEXE3i5tp+qHvEJS7MvcQOYfNKzGh/ClUv
	JzHt6xpmCFta4vysDYwwNy/+/hgqzi9x7PYOJghbQGLqmYNQNVoSn7/vhJrDJ7Fm4VsWmPpd
	p5Yzw+y6v2UuVK+ExNaWJ+AwYRZQlJjS/RDsd2YBTYn1u/TRvcIr4CHxt6GDcQKj7CwkqVlI
	umchdCMrWcDIsopRNLUguaA4Kb3CRK84Mbe4NC9dLzk/dxMjOAU9W7KDseGC9SFGAQ5GJR5e
	Cb1JIUKsiWXFlbmHGCU4mJVEeKNzgEK8KYmVValF+fFFpTmpxYcYTYFxNpFZSjQ5H5ge80ri
	DY2NTcxMTC1NLAxMzZXEef+fyw0REkhPLEnNTk0tSC2C6WPi4JRqYEwNnnbNwmHxlGOFMrem
	FSabmW+9Z7bJZmPr5oAc/bszfijpT7q7VneS5C6eVkeTUK7mgxsW3TwV2SqbHpkce9/izLR/
	P7R8aqU8nfgvzXTLlo28vCtsS9mtDTOYFGpehhffiNOZYThj/gOVA5I7dVtmbl0+d5dIokDz
	PpX6yzxxKwvmr2NZG6XEUpyRaKjFXFScCAANmQFsVwMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBI6OfXK014851

Hi Chanwoo,

I love the idea and I now have a little mechanical issues in your code.

> ---
>  drivers/devfreq/Kconfig         |   2 +
>  drivers/devfreq/Makefile        |   5 +-
>  drivers/devfreq/devfreq-event.c | 449 ++++++++++++++++++++++++++++++++++++++++
>  drivers/devfreq/event/Makefile  |   1 +
>  include/linux/devfreq.h         | 160 ++++++++++++++
>  5 files changed, 616 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/devfreq/devfreq-event.c
>  create mode 100644 drivers/devfreq/event/Makefile
> 
> diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
> index faf4e70..4d15b62 100644
> --- a/drivers/devfreq/Kconfig
> +++ b/drivers/devfreq/Kconfig
> @@ -87,4 +87,6 @@ config ARM_EXYNOS5_BUS_DEVFREQ
>  	  It reads PPMU counters of memory controllers and adjusts the
>  	  operating frequencies and voltages with OPP support.
>  
> +comment "DEVFREQ Event Drivers"
> +
>  endif # PM_DEVFREQ
> diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
> index 16138c9..a1ffabe 100644
> --- a/drivers/devfreq/Makefile
> +++ b/drivers/devfreq/Makefile
> @@ -1,4 +1,4 @@
> -obj-$(CONFIG_PM_DEVFREQ)	+= devfreq.o
> +obj-$(CONFIG_PM_DEVFREQ)		+= devfreq.o devfreq-event.o
>  obj-$(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)	+= governor_simpleondemand.o
>  obj-$(CONFIG_DEVFREQ_GOV_PERFORMANCE)	+= governor_performance.o
>  obj-$(CONFIG_DEVFREQ_GOV_POWERSAVE)	+= governor_powersave.o
> @@ -7,3 +7,6 @@ obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)	+= governor_userspace.o
>  # DEVFREQ Drivers
>  obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos/
>  obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)	+= exynos/
> +
> +# DEVFREQ Event Drivers
> +obj-$(CONFIG_PM_DEVFREQ)		+= event/
> 

It looks getting mature fast.
However, I would like to suggest you to

allow not to compile devfreq-event.c and not include its compiled object
  if devfreq.c is required but devfreq-event.c is not required.
  (e.g., add CONFIG_PM_DEVFREQ_EVENT and let it be enabled when needed)
  just a little concern for lightweight devices.
    (this change might require a bit more work on the header as well)
  - Or do you think devfreq-event.c will become almost mandatory for
   most devfreq drivers?


[snip]

> diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
> new file mode 100644
> index 0000000..0e1948e
> --- /dev/null
> +++ b/drivers/devfreq/devfreq-event.c
> @@ -0,0 +1,449 @@
> +/*
> + * devfreq-event: Generic DEVFREQ Event class driver

DEVFREQ is a generic DVFS mechanism (or subsystem).

Plus, I thought devfreq-event is considered to be a "framework"
for devfreq event class drivers. Am I mistaken?

[snip]

> +struct devfreq_event_dev *devfreq_event_add_edev(struct device *dev,
> +                                               struct devfreq_event_desc *desc)
> +{
> +       struct devfreq_event_dev *edev;
> +       static atomic_t event_no = ATOMIC_INIT(0);
> +       int ret;
> +
> +       if (!dev || !desc)
> +               return ERR_PTR(-EINVAL);
> +
> +       if (!desc->name || !desc->ops)
> +               return ERR_PTR(-EINVAL);
> +
> +       if (!desc->ops->set_event || !desc->ops->get_event)
> +               return ERR_PTR(-EINVAL);
> +
> +       edev = devm_kzalloc(dev, sizeof(*edev), GFP_KERNEL);
> +       if (!edev)
> +               return ERR_PTR(-ENOMEM);
> +
> +       mutex_lock(&devfreq_event_list_lock);

You seem to lock that global lock too long. That lock is only required
while you operate the list. The data to be protected by this mutex is
devfreq_event_list. Until the new entry is added to the list, the new
entry is free from protection. (may be delayed right before list_add)

> +       mutex_init(&edev->lock);
> +       edev->desc = desc;
> +       edev->dev.parent = dev;
> +       edev->dev.class = devfreq_event_class;
> +       edev->dev.release = devfreq_event_release_edev;
> +
> +       dev_set_name(&edev->dev, "event.%d", atomic_inc_return(&event_no) - 1);
> +       ret = device_register(&edev->dev);
> +       if (ret < 0) {
> +               put_device(&edev->dev);
> +               mutex_unlock(&devfreq_event_list_lock);
> +               return ERR_PTR(ret);
> +       }
> +       dev_set_drvdata(&edev->dev, edev);
> +
> +       INIT_LIST_HEAD(&edev->node);
> +       list_add(&edev->node, &devfreq_event_list);
> +       mutex_unlock(&devfreq_event_list_lock);
> +
> +       return edev;
> +}



[snip / reversed maybe.. sorry]

> +/**
> + * devfreq_event_is_enabled() - Check whether devfreq-event dev is enabled or
> + *                             not.
> + * @edev       : the devfreq-event device
> + *
> + * Note that this function check whether devfreq-event dev is enabled or not.
> + * If return true, the devfreq-event dev is enabeld. If return false, the
> + * devfreq-event dev is disabled.
> + */
> +bool devfreq_event_is_enabled(struct devfreq_event_dev *edev)
> +{
> +       bool enabled = false;
> +
> +       if (!edev || !edev->desc)
> +               return enabled;
> +
> +       mutex_lock(&edev->lock);
> +
> +       if (edev->enable_count > 0)
> +               enabled = true;
> +
> +       if (edev->desc->ops && edev->desc->ops->is_enabled)
> +               enabled |= edev->desc->ops->is_enabled(edev);

What does it mean when enabled_count > 0 and ops->is_enabled() is false? or..
What does it mean when enabled_count = 0 and ops->is_enabled() is true?

If you do enable_count in the subsystem, why would we rely on
ops->is_enabled()? Are you assuming that a device MAY turn itself off
without any kernel control (ops->disable()) and it is still a correct
behabior?

> +
> +       mutex_unlock(&edev->lock);
> +
> +       return enabled;
> +}
> +EXPORT_SYMBOL_GPL(devfreq_event_is_enabled);


Cheers,
MyungJoo

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
