Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbaIDEnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 00:43:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55344 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaIDEnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 00:43:19 -0400
X-AuditID: cbfee691-f79546d0000011a1-32-5407ede5232c
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Boris BREZILLON'" <boris.brezillon@free-electrons.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk,
        "'Alexander Shiyan'" <shc_work@mail.ru>, naushad@samsung.com,
        "'Tomasz Figa'" <t.figa@samsung.com>, linux-kernel@vger.kernel.org,
        joshi@samsung.com, linux-samsung-soc@vger.kernel.org,
        thomas.ab@samsung.com, tomasz.figa@gmail.com, vikas.sajjan@samsung.com,
        chow.kim@samsung.com, lee.jones@linaro.org,
        "'Michal Simek'" <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        "'Mark Brown'" <broonie@kernel.org>
References: <1409668935-10667-1-git-send-email-pankaj.dubey@samsung.com>
 <6034841.GFrG3XCMdb@wuerfel> <20140903151611.260a7218@bbrezillon>
 <4224773.hl3QDeILqz@wuerfel> <20140903161528.05f566e1@bbrezillon>
In-reply-to: <20140903161528.05f566e1@bbrezillon>
Subject: RE: [PATCH v2] mfd: syscon: Decouple syscon interface from platform
 devices
Date: Thu, 04 Sep 2014 10:15:27 +0530
Message-id: <002701cfc7fb$110a7350$331f59f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIt001XuICEdFXqks+cH6c/XVPcogHeMPhCAWAIwTABxct1JQJXrpQNmvlwwDA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsWyRsSkTvfpW/YQg8dnxC3+TjrGbnHgxUIW
	i6kPn7BZLJt0l83i+64v7Ba9C66yWdz/epTRYtPja6wWl3fNYbOYcX4fk8Xty7wW715GWHw6
	+p/VYtIOKYuOZYwWq3b9YbS4+Ww7k4OgR0tzD5vH71+TGD2ebLrI6LFz1l12j02rOtk87lzb
	w+axeUm9x5S5R1g9+rasYvT4vEnOY+/n3ywB3FFcNimpOZllqUX6dglcGZ/vGBTsFax4/fc4
	UwPjQt4uRk4OCQETiamn17FB2GISF+6tB7K5OIQEljJK9K5dzQpTtK/9EDtEYjqjxOQ1ncwg
	CSGBv4wSP9skQGw2AV2JJ+/ngsVFBGIlZvTtZwSxmQVuMEucOxEHUX+BUWLzRk8Qm1PAUGL9
	1w1gC4QFwiRmPW5iAbFZBFQl2nd0A83h4OAVsJT41+kKEuYVEJT4MfkeC8RILYn1O48zQdjy
	EpvXvGWGuFNBYsfZ14wQJ/hJ9E5fDVUvLjHpwUOw+yUEbnBITLoLs0tA4tvkQywguyQEZCU2
	HYCaIylxcMUNlgmMErOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFSepGpXnFibnFpXrpecn7u
	JkZgQjn979nEHYz3D1gfYhTgYFTi4S14wR4ixJpYVlyZe4jRFOiiicxSosn5wLSVVxJvaGxm
	ZGFqYmpsZG5ppiTOqyP9M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo3/450vn3h5Ky428
	q7R7DseVOENWx7K24Hk7K5o1mViNAlRn3txlEDfPTuhfj+1yZ7kHixbd0O+Jz/RwfpYwr68n
	2nXy5MeaQvprXV/pv71tLhN2vJkl2iBT7b7FnmepF5yyG2MqVtvcFONstWt22fvky+XOeZ+K
	Hj3my73ZfXrHz8YFQauilViKMxINtZiLihMBYPDdZyMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jQd2nb9lDDP6u57X4O+kYu8WBFwtZ
	LKY+fMJmsWzSXTaL77u+sFv0LrjKZnH/61FGi02Pr7FaXN41h81ixvl9TBa3L/NavHsZYfHp
	6H9Wi0k7pCw6ljFarNr1h9Hi5rPtTA6CHi3NPWwev39NYvR4sukio8fOWXfZPTat6mTzuHNt
	D5vH5iX1HlPmHmH16NuyitHj8yY5j72ff7MEcEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAL2kpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsYcz4fMegYK9gxeu/x5kaGBfydjFyckgImEjsaz/EDmGLSVy4t56ti5GLQ0hg
	OqPE5DWdzCAJIYG/jBI/2yRAbDYBXYkn7+eCxUUEYiVm9O1nBLGZBW4wS5w7EQdRf4FRYvNG
	TxCbU8BQYv3XDawgtrBAmMSsx00sIDaLgKpE+45uoDkcHLwClhL/Ol1BwrwCghI/Jt9jgRip
	JbF+53EmCFteYvOat8wQdypI7Dj7mhHiBD+J3umroerFJSY9eMg+gVFoFpJRs5CMmoVk1Cwk
	LQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBKerZ1I7GFc2WBxiFOBgVOLhLXjBHiLE
	mlhWXJl7iFGCg1lJhHf2WaAQb0piZVVqUX58UWlOavEhRlOgRycyS4km5wNTaV5JvKGxibmp
	samliYWJmaWSOO+BVutAIYH0xJLU7NTUgtQimD4mDk6pBsaVS4pVl8SK9xoEnRA/UirnNenj
	trrAY0q5yyZ6Hbva23VsUzb/ul8r7zToTsk5Z3L9jP2s0ny1SQlXO5RTqj/cna0zjdXnmvNF
	UflpDleXv9c8sZPvcwf7Oo53fwVOLNSIfHw8eIWJx/ua1+FFNdNDdysk71LP/d305M6z3Kgr
	Pw21pzOuO82uxFKckWioxVxUnAgAUnpwIG0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Wednesday, September 03, 2014 Boris BREZILLON wrote,
> To: Arnd Bergmann
> Cc: Pankaj Dubey; kgene.kim@samsung.com; linux@arm.linux.org.uk; Alexander
> Shiyan; naushad@samsung.com; Tomasz Figa; linux-kernel@vger.kernel.org;
> joshi@samsung.com; linux-samsung-soc@vger.kernel.org;
thomas.ab@samsung.com;
> tomasz.figa@gmail.com; vikas.sajjan@samsung.com; chow.kim@samsung.com;
> lee.jones@linaro.org; Michal Simek; linux-arm-kernel@lists.infradead.org;
Mark
> Brown
> Subject: Re: [PATCH v2] mfd: syscon: Decouple syscon interface from
platform
> devices
> 
> On Wed, 03 Sep 2014 15:49:04 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Wednesday 03 September 2014 15:16:11 Boris BREZILLON wrote:
> > > I checked that part, and it appears most of the code is already
> > > there (see usage of regmap_attach_dev function here [1]).
> > >
> > > The only problem I see is that errors are still printed with
> > > dev_err, which, AFAIK, will trigger a kernel panic if dev is NULL.
> >
> > Actually not:
> >
> > static int __dev_printk(const char *level, const struct device *dev,
> >                         struct va_format *vaf) {
> >         if (!dev)
> >                 return printk("%s(NULL device *): %pV", level, vaf);
> >
> >         return dev_printk_emit(level[1] - '0', dev,
> >                                "%s %s: %pV",
> >                                dev_driver_string(dev), dev_name(dev),
> > vaf); }
> >
> 
> My bad then (I don't know where I looked at to think NULL dev was not
gracefully
> handled :-)). Thanks for pointing this out.
> Given that, I think it should work fine even with a NULL dev.
> I'll give it a try on at91 ;-).
> 

We have tested this patch, on Exynos board and found working well.
In our use case DT based drivers such as USB Phy, SATA Phy, Watchdog are
calling 
syscon_regmap_lookup_by APIs to get regmap handle to Exynos PMU and it
worked 
well for these drivers. 

It would be great if after testing you share result here or give a
Tested-By.

Thanks,
Pankaj Dubey 
> Best Regards,
> 
> Boris
> 
> --
> Boris Brezillon, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com

