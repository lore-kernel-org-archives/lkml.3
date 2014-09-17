Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbaIQLTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:19:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16524 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbaIQLT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:19:28 -0400
X-AuditID: cbfee690-f79ce6d00000115a-04-54196e335974
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Dong Aisheng'" <b29396@freescale.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, arnd@arndb.de, naushad@samsung.com,
        tomasz.figa@gmail.com, joshi@samsung.com, thomas.ab@samsung.com,
        vikas.sajjan@samsung.com, chow.kim@samsung.com, lee.jones@linaro.org,
        "'Boris BREZILLON'" <boris.brezillon@free-electrons.com>
References: <1410935510-1567-1-git-send-email-pankaj.dubey@samsung.com>
 <20140917085818.GA10285@shlinux1.ap.freescale.net>
In-reply-to: <20140917085818.GA10285@shlinux1.ap.freescale.net>
Subject: RE: [PATCH v3] mfd: syscon: Decouple syscon interface from platform
 devices
Date: Wed, 17 Sep 2014 16:50:50 +0530
Message-id: <000401cfd269$922dfc40$b689f4c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGAgvNtQpXjUZMClJmM9wWnjoVNAgMenyfbnIrT/hA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42JZI2JSp2ucJxli8Gy+nsXfScfYLR7u7Gex
	OPBiIYvFskl32Sy+7/rCbtG74Cqbxf2vRxktNj2+xmpxedccNosZ5/cxWdy+zGvx6eh/VouO
	ZYwWq3b9YbS4+Ww7kwO/R0tzD5vH71+TGD2ebLrI6PHvcD+Tx85Zd9k97lzbw+axeUm9R9+W
	VYwenzfJBXBGcdmkpOZklqUW6dslcGVM33OYpeCeQMW19sOsDYz/eboYOTkkBEwkXqz+zg5h
	i0lcuLeerYuRi0NIYCmjRGfrFVaYon/bJzBCJKYzSvQ/XMMK4fxllHj3exUbSBWbgK7Ek/dz
	mUFsEQFNied7XoMVMQs0M0u8fHKVESQhJFAj0fZxBdg+TgF7iR2b1oA1CwuESVztPQ8U5+Bg
	EVCVWNCiAxLmFbCUeHvtITuELSjxY/I9FhCbWUBLYv3O40wQtrzE5jVvmSEuVZDYcfY1I8QN
	VhJr1jyHqheXmPQAZA4XUM0BDomTTx+DDWUREJD4NvkQC8heCQFZiU0HoOZIShxccYNlAqPE
	LCSrZyFZPQvJ6llIVixgZFnFKJpakFxQnJReZKJXnJhbXJqXrpecn7uJEZgyTv97NmEH470D
	1ocYBTgYlXh4N1yWCBFiTSwrrsw9xGgKdNFEZinR5HxgYsoriTc0NjOyMDUxNTYytzRTEud9
	LfUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjhlno8n2661Pu7N73Ulzg2kIz47v/+45v
	LuPY+KN0gmOhRwQfy4/klC31p7TCuvMmVC3ZYGryLU5Vsrbq4Y+gE+fFmgXmCa11CHNxuB7D
	6bVoUejbagud81z6OyIOfNETf9HyY959Zs81HbusDR9+XH/2ddGOR+9qOg6enXX79/7AhV/F
	V3b/U2Ipzkg01GIuKk4EAMNoKUMUAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jQV3jPMkQg027VSz+TjrGbvFwZz+L
	xYEXC1kslk26y2bxfdcXdoveBVfZLO5/PcposenxNVaLy7vmsFnMOL+PyeL2ZV6LT0f/s1p0
	LGO0WLXrD6PFzWfbmRz4PVqae9g8fv+axOjxZNNFRo9/h/uZPHbOusvucefaHjaPzUvqPfq2
	rGL0+LxJLoAzqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUn
	QNctMwfoASWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxvQ9h1kK7glU
	XGs/zNrA+J+ni5GTQ0LAROLf9gmMELaYxIV769m6GLk4hASmM0r0P1zDCuH8ZZR493sVG0gV
	m4CuxJP3c5lBbBEBTYnne16DFTELNDNLvHxyFWyUkECNRNvHFewgNqeAvcSOTWvAmoUFwiSu
	9p4HinNwsAioSixo0QEJ8wpYSry99pAdwhaU+DH5HguIzSygJbF+53EmCFteYvOat8wQlypI
	7Dj7mhHiBiuJNWueQ9WLS0x68JB9AqPQLCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdIr
	TswtLs1L10vOz93ECE5Iz6R3MK5qsDjEKMDBqMTDu+GyRIgQa2JZcWXuIUYJDmYlEd6+YMkQ
	Id6UxMqq1KL8+KLSnNTiQ4ymQI9OZJYSTc4HJsu8knhDYxNzU2NTSxMLEzNLJXHeg63WgUIC
	6YklqdmpqQWpRTB9TBycUg2MGmf70gznXKiyunXjpA1rcG9hhOUihmWKE18zXrpfEVK+LPmc
	42Oh2Qnz3C79fN85dZPq2gf7P9sFV126ZqLKcPX8o+VCc1RbPSNFUqN3qj3dZOfyRtD1wd4V
	vZ8zZ1x9JdFxZNsJ1xO92azcJ/5fOejVxVsyZ8FPm5DOo09fWxRLy3c6hn0LU2Ipzkg01GIu
	Kk4EALODQ1ReAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, September 17, 2014, Dong Aisheng Wrote,
> >
> > +static struct syscon *of_syscon_register(struct device_node *np) {
> > +	struct syscon *syscon;
> > +	struct regmap *regmap;
> > +	void __iomem *base;
> > +
> > +	if (!of_device_is_compatible(np, "syscon"))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
> > +	if (!syscon)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	base = of_iomap(np, 0);
> > +	if (!base)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	regmap = regmap_init_mmio(NULL, base, &syscon_regmap_config);
> 
> Does a NULL device pointer work?

Yes, it is safe, at least we are able to test on Exynos based SoC. 
I have tested it with kgene/for-next kernel on Exynos3250.
Also it has been tested on Exynos5250 based Snow board with 3.17-rc5 based
kernel
by Vivek Gautam. 

Patch V2 also has been tested by "Borris Brezillon" on AT91 platform.


> I just tested on MX6SX SDB board and it seemed crashed at here in
regmap_init
> function.
> 

Can you please provide crash log which can give more information about the
crash?


Thanks,
Pankaj Dubey

> Regards
> Dong Aisheng
> 
> > +	if (IS_ERR(regmap)) {
> > +		pr_err("regmap init failed\n");
> > +		return ERR_CAST(regmap);
> > +	}
> > +
> > +	syscon->regmap = regmap;
> > +	syscon->np = np;
> > +
> > +	spin_lock(&syscon_list_slock);
> > +	list_add_tail(&syscon->list, &syscon_list);
> > +	spin_unlock(&syscon_list_slock);
> > +
> > +	return syscon;
> > +}
> > +
> >  static int syscon_probe(struct platform_device *pdev)  {
> >  	struct device *dev = &pdev->dev;
> > @@ -167,7 +204,6 @@ static struct platform_driver syscon_driver = {
> >  	.driver = {
> >  		.name = "syscon",
> >  		.owner = THIS_MODULE,
> > -		.of_match_table = of_syscon_match,
> >  	},
> >  	.probe		= syscon_probe,
> >  	.id_table	= syscon_ids,
> > --
> > 1.7.9.5
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

