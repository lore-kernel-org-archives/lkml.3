Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaIZF3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 01:29:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29821 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbaIZF3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 01:29:17 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-84-5424f9a62461
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, Li.Xiubo@freescale.com,
        linux-arm-kernel@lists.infradead.org
Cc: "'Dong Aisheng'" <b29396@freescale.com>, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, naushad@samsung.com,
        linux-kernel@vger.kernel.org, tomasz.figa@gmail.com,
        thomas.ab@samsung.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        joshi@samsung.com, lee.jones@linaro.org, kgene.kim@samsung.com
References: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com>
 <20140922091925.GA19778@shlinux1.ap.freescale.net>
 <000001cfd719$51e7e560$f5b7b020$@samsung.com> <5439567.VeRyeUcp1j@wuerfel>
In-reply-to: <5439567.VeRyeUcp1j@wuerfel>
Subject: RE: [PATCH v5] mfd: syscon: Decouple syscon interface from platform
 devices
Date: Fri, 26 Sep 2014 10:58:33 +0530
Message-id: <000e01cfd94a$c5c60510$51520f30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKkPpk+xGsfKb8cRzoLv6q27vvt4QIYhcStAuEaOoMCrbGLPZos1VUQ
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsWyRsSkRnf5T5UQg3knmS3+TjrGbvFwZz+L
	xbJJd9ksvu/6wm7Ru+Aqm8X9r0cZLTovdLBabHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBYd
	yxgtVu36w2hx89l2Jgd+j5bmHjaP378mMXr8O9zP5LFz1l12jzvX9rB5bF5S79G3ZRWjx+dN
	cgEcUVw2Kak5mWWpRfp2CVwZq+5UF1zVqFhzeD1jA+NU+S5GTg4JAROJlv4r7BC2mMSFe+vZ
	uhi5OIQEljJKrLr2jhGmaPu068wgtpDAIkaJ1zt0IYr+MkocODmFBSTBJqAr8eT9XKAiDg4R
	gWSJC48TQMLMAnuZJE79DIOoP8kosannO1g9p4CmxLcJD9lAbGGBMIk/h5qZQGwWAVWJttNt
	YBfxClhKfOqYxwZhC0r8mHyPBWKolsT6nceZIGx5ic1r3jJDHKogsePsa7CjRQTcJP7snMkI
	USMuMenBQ3aQIyQEtnBITFn2kBVimYDEt8mHWECOlhCQldh0AGqOpMTBFTdYJjBKzEKyehaS
	1bOQrJ6FZMUCRpZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGIFJ4vS/ZxN2MN47YH2IUYCD
	UYmHt2GNSogQa2JZcWXuIUZToIsmMkuJJucDU1FeSbyhsZmRhamJqbGRuaWZkjjva6mfwUIC
	6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYV68QrnJwnLtdX2vant7pS3I4n0aE+Kbqv/PVqq1f
	Lu5x+uRezrgvM5lZVmsYLJJ8e3due71mQ/7RrS/2r5eQXCEZ9/ady7TpKgzMh9eFvJ1i+7X3
	hR5LamVCXuiaGNXXUhFTYtfXflPklj2sLHbkvD3f9veKtp5WmqmtR1hNZq54KHqz9ZG2Ektx
	RqKhFnNRcSIAK7RSFA0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jAd1lP1VCDL6uNbf4O+kYu8XDnf0s
	Fssm3WWz+L7rC7tF74KrbBb3vx5ltOi80MFqsenxNVaLy7vmsFnMOL+PyeL2ZV6LT0f/s1p0
	LGO0WLXrD6PFzWfbmRz4PVqae9g8fv+axOjx73A/k8fOWXfZPe5c28PmsXlJvUffllWMHp83
	yQVwRDUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA
	3a6kUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzFh1p7rgqkbFmsPrGRsY
	p8p3MXJySAiYSGyfdp0ZwhaTuHBvPRuILSSwiFHi9Q7dLkYuIPsvo8SBk1NYQBJsAroST97P
	BWrg4BARSJa48DgBJMwssJdJ4tTPMIj6k4wSm3q+g9VzCmhKfJvwEGyosECYxJ9DzUwgNouA
	qkTb6TZ2EJtXwFLiU8c8NghbUOLH5HssEEO1JNbvPM4EYctLbF7zFupQBYkdZ18zgtgiAm4S
	f3bOZISoEZeY9OAh+wRGoVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66X
	nJ+7iRGcgp5J72Bc1WBxiFGAg1GJh7dhjUqIEGtiWXFl7iFGCQ5mJRHeyDdAId6UxMqq1KL8
	+KLSnNTiQ4ymQJ9OZJYSTc4Hpse8knhDYxNzU2NTSxMLEzNLJXHeg63WgUIC6YklqdmpqQWp
	RTB9TBycUg2MtUKvvqyeOm3a1C/HDXoFFaZtbVlm83Z6xn/eEwLSiwKY5gRMlT+6YT73o7K9
	jO5xr3K1A1fvX+zV9/5G8PV+WQ/fzQf/G0rk/M3IKBc3Yepu+X0/UXJB+yTTrA0LJ24+dKoj
	ikP0psfiF5ei87/dmDzTdWlBP/N9T507u0Jmf3mkGcuzU1ntjBJLcUaioRZzUXEiAC7BP2FX	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 25, 2014 6:12 PM, Arnd Bergmann wrote,
> Subject: Re: [PATCH v5] mfd: syscon: Decouple syscon interface from
platform
> devices
> 
> On Tuesday 23 September 2014 15:59:43 Pankaj Dubey wrote:
> > > > -static int syscon_match_node(struct device *dev, void *data)
> > > > +static struct syscon *of_syscon_register(struct device_node *np)
> > > >  {
> > > > -   struct device_node *dn = data;
> > > > +   struct platform_device *pdev = NULL;
> > > > +   struct syscon *syscon;
> > > > +   struct regmap *regmap;
> > > > +   void __iomem *base;
> > > > +   int ret;
> > > > +
> > > > +   if (!of_device_is_compatible(np, "syscon"))
> > > > +           return ERR_PTR(-EINVAL);
> > > > +
> > > > +   syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
> > > > +   if (!syscon)
> > > > +           return ERR_PTR(-ENOMEM);
> > > > +
> > > > +   base = of_iomap(np, 0);
> > > > +   if (!base) {
> > > > +           ret = -ENOMEM;
> > > > +           goto err_map;
> > > > +   }
> > > > +
> > > > +   /* if device is already populated and available then use it */
> > > > +   pdev = of_find_device_by_node(np);
> > > > +   if (!pdev) {
> > > > +           /* for early users create dummy syscon device and use it
*/
> > > > +           pdev = platform_device_alloc("dummy-syscon", -1);
> > >
> > > Can we create specific devices for each syscon device?
> > > That looks more reasonable to me.
> > > Then we can dump registers in regmap debugfs more clearly, just like
> > > other
> > devices.
> > > And i think it's better to follow device tree way to generate
> > > devices from
> > node.
> > > If DT core find a device is already created, it can ignore that
> > > device to
> > avoid creating
> > > duplicated device during of_platform_populate.
> > >
> >
> > If you are referring to use "of_platform_device_create", then I am
> > afraid that it can't be used in very early stage. For example, current
> > patch I tested by calling syscon_lookup_by_phandle from "init_irq"
> > hook of machine_desc, and it worked well, but If I use
> > "of_platform_device_create"
> > instead of dummy device, it fails to create pdev and this I verified
> > on Exynos platform. The reason I selected "init_irq" is because this
> > comes just before smp init and where once we tried to get regmap
> > handle, but could not do so.
> 
> I don't remember noticing the of_find_device_by_node or
platform_device_alloc in
> earlier versions of this patch, but that could just be me failing to read
it right.
> 
Yes, till v2 of this patch set we do not used this and while calling
regmap_init_mmio, I used
NULL pointer while creating regmap handle.  But as you may be remember Dong
Aisheng reported crash
on latest Linus tree after applying this patch, and it caused because of
some recent changes in
regmap which has already landed in main tree, which makes passing of dev
pointer compulsory
while calling regmap_init_mmio. Please check following commits in current
tree

1) d647c19 regmap: add DT endianness binding support.
2) ba1b53f regmap: Fix DT endianess parsing logic.
3) 45e1a27 regmap: of_regmap_get_endian() cleanup

and following patch [1] for changing syscon binding from Xiubo Li

[1] [PATCH] mfd: syscon: binding: Add syscon endianness support
https://lkml.org/lkml/2014/9/18/67

So we discussed [2] and decided to use either actual device if it's
populated and available for use or
create either actual device or dummy device for using it during
regmap_init_mmio calls.

[2]: https://lkml.org/lkml/2014/9/18/35

So what I understood from these changes from Xiubo Li, they wanted to pass
endianness of regmap
handle to be passed from DT. 

So I am not sure if we can really make regmap code work without a device
pointer. 

> I think this should get removed: it would be much better to ensure that
the regmap
> code can work without a device pointer, which I thought it did. We should
probably
> also skip the creation of the debugfs directory in that case.
> 
> > Also if it was just a matter of creating platform_device at early
> > stage then early initialization of syscon could have been solved till
> > now.

As far as debugfs of regmap is concerned it can be solved as I replied to
Heiko in this thread [3]
if we are using device pointer while creating regmap handle. 
If we are not using device pointer while creating regmap handle it won't
cause any problem and 
there won't be any debugfs entry.

[3]: https://lkml.org/lkml/2014/9/26/20

> >
> > So I would suggest if we really want this patch to cover early
> > initialization of syscon (which is not it's main purpose) current
> > patch is sufficient.
> >
> > @Arnd, since I have addressed crash issue as reported by Dong Aisheng,
> > I would like to take your ack, but since there are some more code
> > changes other than what you suggested I request you to check this and
> > if you are ok, then I would like to your ack so that I can request to
> > maintainer for taking this patch.
> 
> I think we first need to resolve the question of the platform device.
> 

OK.

Thanks,
Pankaj Dubey

> 	Arnd

