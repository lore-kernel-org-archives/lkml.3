Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbaIPLvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:51:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40786 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbaIPLvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:51:51 -0400
X-AuditID: cbfee68f-f797f6d000001173-c9-541824544ba7
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, lee.jones@linaro.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk,
        "'Alexander Shiyan'" <shc_work@mail.ru>, naushad@samsung.com,
        "'Tomasz Figa'" <t.figa@samsung.com>, linux-kernel@vger.kernel.org,
        joshi@samsung.com, linux-samsung-soc@vger.kernel.org,
        thomas.ab@samsung.com, tomasz.figa@gmail.com, vikas.sajjan@samsung.com,
        chow.kim@samsung.com, "'Michal Simek'" <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Boris BREZILLON'" <boris.brezillon@free-electrons.com>,
        PRASHANTH GODREHAL <prashanth.g@samsung.com>
References: <1409668935-10667-1-git-send-email-pankaj.dubey@samsung.com>
 <6034841.GFrG3XCMdb@wuerfel> <20140903151611.260a7218@bbrezillon>
 <4224773.hl3QDeILqz@wuerfel> <20140903161528.05f566e1@bbrezillon>
 <002701cfc7fb$110a7350$331f59f0$@samsung.com>
 <20140905101409.68b14cc3@bbrezillon>
In-reply-to: <20140905101409.68b14cc3@bbrezillon>
Subject: RE: [PATCH v2] mfd: syscon: Decouple syscon interface from platform
 devices
Date: Tue, 16 Sep 2014 17:23:55 +0530
Message-id: <000b01cfd1a4$f5ae0d20$e10a2760$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIt001XuICEdFXqks+cH6c/XVPcogHeMPhCAWAIwTABxct1JQJXrpQNAqmN76oCXbCQrZrkg6mw
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsWyRsSkRjdURSLEYOFBZou/k46xWxx4sZDF
	YurDJ2wWyybdZbP4vusLu0XvgqtsFve/HmW02PT4GqvF5V1z2CxmnN/HZHH7Mq/Fu5cRFp+O
	/me1WHV4A7vFpB1SFh3LGC1W7frDaHHz2XYmByGPluYeNo/fvyYxejzZdJHRY+esu+wem1Z1
	snncubaHzWPzknqPKXOPsHr0bVnF6PF5k5zH3s+/WQK4o7hsUlJzMstSi/TtErgyTvQ1sBac
	U6jYeraHtYGxSbKLkZNDQsBE4u+y2WwQtpjEhXvrgWwuDiGBpYwSR5b8Z4IpunO/DSqxiFHi
	14e7rBDOX0aJqfues4BUsQnoSjx5P5cZxBYRsJQ4uHMNmM0ssIZFYv9Sf4iG5UwSpw7tAmvg
	FDCUaFlzlx3EFhYIk5j1uAksziKgKnFlxzwwmxdoUMeWn0wQtqDEj8n3WCCGakms33mcCcKW
	l9i85i0zxKkKEjvOvmaEOCJG4vnUNVA14hKTHjxkh6i5wSFxod0VYpeAxLfJh4BmcgDFZSU2
	HYAaIylxcMUNlgmMErOQbJ6FZPMsJJtnIdmwgJFlFaNoakFyQXFSepGxXnFibnFpXrpecn7u
	JkZggjn971n/Dsa7B6wPMQpwMCrx8Ho8Eg8RYk0sK67MPcRoCnTRRGYp0eR8YBrLK4k3NDYz
	sjA1MTU2Mrc0UxLnXSj1M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY/dLizmhSxrmd3P+
	qnobcGlvuNEBE6eXPB7alXzPy/6ZPMj8qCd1LLXgyautq078l1760Gt1w7Qnp4MazPLO7tv+
	6r1Yf0vIs/hKg/Sjdz+oXGjZkHhqk/yq/GsyxvPzv8fa7pVI8pm6O9/4krum4/93rRI6N8pe
	nC7QWiBx8W1kUcFK5gbDhUosxRmJhlrMRcWJAL+bcVwrAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jAd0QFYkQg22nTCz+TjrGbnHgxUIW
	i6kPn7BZLJt0l83i+64v7Ba9C66yWdz/epTRYtPja6wWl3fNYbOYcX4fk8Xty7wW715GWHw6
	+p/VYtXhDewWk3ZIWXQsY7RYtesPo8XNZ9uZHIQ8Wpp72Dx+/5rE6PFk00VGj52z7rJ7bFrV
	yeZx59oeNo/NS+o9psw9wurRt2UVo8fnTXIeez//ZgngjmpgtMlITUxJLVJIzUvOT8nMS7dV
	8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB+ktJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjDmHGir4G14JxCxdazPawNjE2SXYycHBICJhJ37rexQdhiEhfurQey
	uTiEBBYxSvz6cJcVwvnLKDF133MWkCo2AV2JJ+/nMoPYIgKWEgd3rgGzmQXWsEjsX+oP0bCc
	SeLUoV1gDZwChhIta+6yg9jCAmESsx43gcVZBFQlruyYB2bzAg3q2PKTCcIWlPgx+R4LxFAt
	ifU7jzNB2PISm9e8ZYY4VUFix9nXjBBHxEg8n7oGqkZcYtKDh+wTGIVmIRk1C8moWUhGzULS
	soCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcAJ7Jr2DcVWDxSFGAQ5GJR5ej0fiIUKs
	iWXFlbmHGCU4mJVEeDUUJUKEeFMSK6tSi/Lji0pzUosPMZoCfTqRWUo0OR+YXPNK4g2NTcxN
	jU0tTSxMzCyVxHkPtloHCgmkJ5akZqemFqQWwfQxcXBKNTDWTBI5K5TH6TX35prPdfpzs3cI
	H5Y9lvv7u8bvO6/6wzrPPTxW287+Qvd8xJwp0RpuTkvTNGcXJB5jdT0+573auRMtn21LDYo/
	xcQ5C132vTHfb+rfhhD1HZJS6iesfp16fv1zl0vLusO3GTOUZ02+Vpv19rbbv8f+Z6ODgoJm
	eudpXv+6JoRLiaU4I9FQi7moOBEA7X6DCXYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,  Lee Jones,


[snip]
> 
> On Thu, 04 Sep 2014 10:15:27 +0530
> Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> 
> > Hi Boris,
> >
> > On Wednesday, September 03, 2014 Boris BREZILLON wrote,
> > > To: Arnd Bergmann
> > > Cc: Pankaj Dubey; kgene.kim@samsung.com; linux@arm.linux.org.uk;
> > > Alexander Shiyan; naushad@samsung.com; Tomasz Figa;
> > > linux-kernel@vger.kernel.org; joshi@samsung.com;
> > > linux-samsung-soc@vger.kernel.org;
> > thomas.ab@samsung.com;
> > > tomasz.figa@gmail.com; vikas.sajjan@samsung.com;
> > > chow.kim@samsung.com; lee.jones@linaro.org; Michal Simek;
> > > linux-arm-kernel@lists.infradead.org;
> > Mark
> > > Brown
> > > Subject: Re: [PATCH v2] mfd: syscon: Decouple syscon interface from
> > platform
> > > devices
> > >
> > > On Wed, 03 Sep 2014 15:49:04 +0200
> > > Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > > On Wednesday 03 September 2014 15:16:11 Boris BREZILLON wrote:
> > > > > I checked that part, and it appears most of the code is already
> > > > > there (see usage of regmap_attach_dev function here [1]).
> > > > >
> > > > > The only problem I see is that errors are still printed with
> > > > > dev_err, which, AFAIK, will trigger a kernel panic if dev is NULL.
> > > >
> > > > Actually not:
> > > >
> > > > static int __dev_printk(const char *level, const struct device *dev,
> > > >                         struct va_format *vaf) {
> > > >         if (!dev)
> > > >                 return printk("%s(NULL device *): %pV", level,
> > > > vaf);
> > > >
> > > >         return dev_printk_emit(level[1] - '0', dev,
> > > >                                "%s %s: %pV",
> > > >                                dev_driver_string(dev),
> > > > dev_name(dev), vaf); }
> > > >
> > >
> > > My bad then (I don't know where I looked at to think NULL dev was
> > > not
> > gracefully
> > > handled :-)). Thanks for pointing this out.
> > > Given that, I think it should work fine even with a NULL dev.
> > > I'll give it a try on at91 ;-).
> > >
> >
> > We have tested this patch, on Exynos board and found working well.
> > In our use case DT based drivers such as USB Phy, SATA Phy, Watchdog
> > are calling syscon_regmap_lookup_by APIs to get regmap handle to
> > Exynos PMU and it worked well for these drivers.
> >
> > It would be great if after testing you share result here or give a
> > Tested-By.
> >
> 
> I eventually tested it (just required minor modifications to my PMC
> code: see below).
> Still, this patch is not achieving my final goal which is to remove the
global
> at91_pmc_base variable and make use of the syscon regmap to implement at91
cpu
> idle and platform suspend.
> Moreover, I'd like to remove the lock in at91_pmc struct as regmap is
already taking
> care of locking the resources when accessing a register, but this requires
a lot more
> changes.
> 
> Anyway, here is my
> 
> Tested-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> 

Any update on this patch. As already it has been tested on two DT based
platforms.

If you think that we can go ahead and break clps711x till it gets migrated
over DT,
then please ack this patch, or else if you have opinion to keep support for
non-DT
based drivers (clps711x) then I can post another patch keeping platform
driver support
for non-DT based platform. 

I would prefer is to keep platform driver support for non-DT based platform
so that this patch set can go in this merge window, as lot of Exynos PMU
patches
(PMU patches of many Exynos SoCs [2,3,4] ) are critically dependent on this
change. 

As per discussion here [1], clps711x SPI and TTY driver patches still has to
be posted
which may take one more merge window, and eventually will drag this patch
also.

[1]:
https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg36291.html
[2]:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/275675.html
[3]:
https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35701.html
[4]: http://www.spinics.net/lists/arm-kernel/msg358230.html


> 
> 
[snip]

Thanks,
Pankaj Dubey

