Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbaHUOG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:06:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49242 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbaHUOG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:06:57 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-ff-53f5fcfe6ab3
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        t.figa@samsung.com, vikas.sajjan@samsung.com, joshi@samsung.com,
        naushad@samsung.com, thomas.ab@samsung.com, chow.kim@samsung.com,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        PRASHANTH GODREHAL <prashanth.g@samsung.com>
References: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com>
 <53D238E1.3030901@gmail.com> <002601cfaa11$93de5060$bb9af120$@samsung.com>
 <2491338.uD82s4TcKJ@amdc1032> <53F35F94.1010101@gmail.com>
In-reply-to: <53F35F94.1010101@gmail.com>
Subject: RE: [PATCH v7 3/4] ARM: EXYNOS: Add platform driver support for Exynos
 PMU
Date: Thu, 21 Aug 2014 19:37:31 +0530
Message-id: <001601cfbd49$72359450$56a0bcf0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQC8Xg2wTqZTg6oaD/ugBpVTcwknCgHGy3ISAUNqbOoCryVM0QFTuV7bnclnP3A=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsWyRsSkTvf/n6/BBj8esFn8nXSM3WLjjPWs
	Fssm3WWz+L7rC7tF74KrbBb3vx5ltNj0+BqrxeVdc9gsZpzfx2Rx+zKvxaej/1ktVh3ewG6x
	fsZrFouOZYwWq3b9YbS4+Ww7k4OAR0tzD5vH71+TGD12zrrL7nHn2h42j81L6j36tqxi9Pi8
	SS6APYrLJiU1J7MstUjfLoEr4+zHrawFk+Uqjly6yNbAeFu8i5GTQ0LAROLojJ+MELaYxIV7
	69m6GLk4hASWMkrcvrCJGaaobdJEqMQiRolVvWtYIZy/jBIfl61lBaliE9CVePJ+LjNIQkRg
	FaNE/7MX7CAOs8AjJon3Uw4zQbRcYpRYsngKSxcjBwengKbE6S2cIN3CAqESs3aeYwKxWQRU
	JVr3f2MDsXkFLCU2X9gGZQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW6hbFSR2nH0N9pCIgJ/E
	wz0X2SBqxCUmPXgIdpCEwB4OiXeTj7FALBOQ+Db5ENg9EgKyEpsOQM2RlDi44gbLBEaJWUhW
	z0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIzBZnP73rHcH4+0D1ocY
	k4HWT2SWEk3OByabvJJ4Q2MzIwtTE1NjI3NLM9KElcR5kx4mBQkJpCeWpGanphakFsUXleak
	Fh9iZOLglGpg3Hi9a5n9yh6T6Z/S9/35fK4ytOYmw12Dv9l6+x3mtkbbT7X8/VtyavCvpryK
	WDPDIG2f9XmPpjkyTls//ftJd1Pfyyed57yYel368M5futusz/W/Fooyu9Bsq9ywYN/Pqc06
	Kvc8ZQv9qytXdqTePCbOJiM+6/vl8hU77p3KOF76cg1z/O9LiUosxRmJhlrMRcWJAB1CdUEs	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jAd1/f74GG7Q9trT4O+kYu8XGGetZ
	LZZNustm8X3XF3aL3gVX2Szufz3KaLHp8TVWi8u75rBZzDi/j8ni9mVei09H/7NarDq8gd1i
	/YzXLBYdyxgtVu36w2hx89l2JgcBj5bmHjaP378mMXrsnHWX3ePOtT1sHpuX1Hv0bVnF6PF5
	k1wAe1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO
	0O1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoyzH7eyFkyWqzhy6SJb
	A+Nt8S5GTg4JAROJtkkT2SBsMYkL99YD2VwcQgKLGCVW9a5hhXD+Mkp8XLaWFaSKTUBX4sn7
	ucwgCRGBVYwS/c9esIM4zAKPmCTeTznMBNFyiVFiyeIpLF2MHBycApoSp7dwgnQLC4RKzNp5
	jgnEZhFQlWjd/w1sN6+ApcTmC9ugbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywxxq4LEjrOv
	GUFsEQE/iYd7LrJB1IhLTHrwkH0Co9AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs810itO
	zC0uzUvXS87P3cQITkXPpHcwrmqwOMQowMGoxMMb8eVrsBBrYllxZe4hRgkOZiUR3vsgId6U
	xMqq1KL8+KLSnNTiQ4ymQJ9OZJYSTc4Hpsm8knhDYxNzU2NTSxMLEzNLJXHeg63WgUIC6Ykl
	qdmpqQWpRTB9TBycUg2MsxYuvBWU2munr9Gic2IF36eA/yw3ZF47C+8z7HsgUZCpUM/P6O8t
	b2lS2TlrcsM5FxsDS+7tF8xsHAqWp/vsv3YhZatABn/17Jvfw/9z/ly/xN1zQbFP8yEJ47ex
	np3JwrMPvrm8qX/y7vKy6IT1E2Nvzn/K/Ead2d7iFdOqUyv8vkbGTXdXYinOSDTUYi4qTgQA
	hvP4/VsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Arnd, Lee Jones

Hi Tomasz,

On Tuesday, August 19, 2014 Tomasz Figa wrote:

> 
> Hi Bart,
> 
> On 18.08.2014 19:42, Bartlomiej Zolnierkiewicz wrote:
> >
> > Hi,
> >
> > On Monday, July 28, 2014 08:40:52 AM Pankaj Dubey wrote:
> >> Hi Tomasz,
> >>
> >> On Friday, July 25, 2014 Tomasz Figa wrote:
> >>
> >>> To: Pankaj Dubey; 'Kukjin Kim';
> >>> linux-arm-kernel@lists.infradead.org;
> >> linux-
> >>> samsung-soc@vger.kernel.org; linux-kernel@vger.kernel.org
> >>> Cc: linux@arm.linux.org.uk; t.figa@samsung.com;
> >>> vikas.sajjan@samsung.com; joshi@samsung.com; naushad@samsung.com;
> >>> thomas.ab@samsung.com; chow.kim@samsung.com
> >>> Subject: Re: [PATCH v7 3/4] ARM: EXYNOS: Add platform driver support
> >>> for Exynos PMU
> >>>
> >>> Hi Pankaj, Kukjin,
> >>>
> >>> On 25.07.2014 07:32, Pankaj Dubey wrote:
> >>>> Hi Kukjin,
> >>>>
> >>>> On Friday, July 25, 2014 Kukjin Kim wrote:
> >>>
> >>> [snip]
> >>>
> >>>>>>
> >>>>> Looks good to me, will apply this and 4/4.
> >>>>>
> >>>>
> >>>> We need to hold these two patches until dependent patch [1] from
> >>>> Tomasz Figa gets merged.
> >>>>
> >>>> [1]: mfd: syscon: Decouple syscon interface from syscon devices
> >>>>       https://lkml.org/lkml/2014/6/24/188
> >>>
> >>> That RFC patch had few comments from Arnd needed to be addressed, so
> >>> it
> >> needs a
> >>> new revision.
> >>>
> >>> Pankaj, If I remember correctly, we had talked about this and the
> >> conclusion was that
> >>> you would take care of addressing the comments and sending new
> >>> version of
> >> the
> >>> patch. Any update on this or have I missed something?
> >>>
> >>
> >> Well, I don't think we concluded as such anything.
> >> Since this patch needs to get in so that Exynos PMU and PM related
> >> changes can go in, I discussed with you saying that I am not able to
> >> understand about Arnd's comments and if possible and time permits I
> >> will look into it. Meanwhile I got busy with some other official
> >> work, so could not get time to look into it.
> >
> > Tomasz/Pankaj, could we please get some agreement on what needs to be
> > done and who should do the pending work?
> >
> > syscon patch is blocking PMU cleanup patches which in turn are
> > blocking PMU support additions for new SoCs (Exynos5420/5800 and
> > Exynos3250 PMU patches).
> 
> Leaving alone the matter who is going to take care of it for now, the
remaining work
> to do is to further decouple syscon from struct device, which means
providing of_
> API to register a syscon provider on a device tree node even before driver
model is
> available yet.
> 

As per Arnd's comment on your RFC patch he mentioned -
"I believe the part you are missing is that with the approach I suggested,
there would be no registration function at all."

I think he is not in favor of adding such registration function at all. So
do you think
adding such function will really solve the problem?

Further even Lee Jones agreed to Arnd's point of making syscon independent
of device,
but he also mentioned that it can be done in subsequent patch.
  
So in IMHO, your RFC patch can be taken as is, and any further improvement
suggested
by Arnd can be done in subsequent patches,  because as I can see in 3.17-rc1
still
has user of syscon_regmap_lookup_by_pdevname (clps711x.c) so we can't
completely
make it independent of platform_device as of now and also the changes
required
as per Arnd's suggestions requires considerable effort and time.

> I believe it should be quite straightforward on top of my RFC and should
require only
> saving syscon's of_node directly in syscon struct, adding appropriate API
and
> extending the look-up loops to handle cases when syscon's dev is NULL.
> 
> Best regards,
> Tomasz

Thanks,
Pankaj Dubey

