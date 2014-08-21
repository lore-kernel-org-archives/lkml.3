Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaHUFLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 01:11:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43739 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaHUFLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 01:11:12 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-3e-53f57f6d8392
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
Cc: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Kamil Debski'" <k.debski@samsung.com>,
        "'Mark Brown'" <broonie@linaro.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Linux USB Mailing List'" <linux-usb@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
 <1408026327-31437-4-git-send-email-b.zolnierkie@samsung.com>
 <34FCC3B2EE8F481198CEF3037F168FB3@sisodomain.com>
 <3463371.y41zGdSnsX@amdc1032> <53F1E1EA.8060708@gmail.com>
 <CAFp+6iGtMUEncFwJ=B_p=q8Bs_O9EMyjsL+ZP9PveO=VMrLmpA@mail.gmail.com>
In-reply-to: <CAFp+6iGtMUEncFwJ=B_p=q8Bs_O9EMyjsL+ZP9PveO=VMrLmpA@mail.gmail.com>
Subject: Re: [PATCH 3/5] usb: phy: samsung: remove old USB 2.0 PHY driver
Date: Thu, 21 Aug 2014 14:11:09 +0900
Message-id: <008601cfbcfe$51a70890$f4f519b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+8+KrF12Xq8jirS3qbz4B065NzdgABWqWQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+Zvm5u/ddgg3XtBhYbZ6xntTh4v95i
	0/XrrBZtVw6yW1xeeInV4sfrC2wWvQuusllceNrDZnG26Q1QYtccNosZ5/cxWSxa1spssWrX
	H0YHXo+ds+6ye9y5tofNo2/LKkaP4ze2M3l83iQXwBrFZZOSmpNZllqkb5fAlfH52Q2WgrN8
	FQ/XPmZqYDzP3cXIySEhYCKxbO0+dghbTOLCvfVsXYxcHEICyxglPjxezgxTdHTSQqjEdEaJ
	+Qv72SGc34wSG879BmtnE1CT+PLlMJgtIhAmsevwXbAOZoGTzBKNB1exgSSEBPYzSXR3Z4HY
	nALBEntfvWQBsYUFPCW2L7rLBGKzCKhKLJzynhHE5hWwlTj4by0rhC0o8WPyPbB6ZgF1iUnz
	FjFD2PISm9e8BbI5gE5Vl3j0VxfiBiOJT3c2QpWISOx78Y4R5B4JgYkcEhdunmGF2CUg8W3y
	IRaIXlmJTQegPpaUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IUK84Mbe4
	NC9dLzk/dxMjJPZ7dzDePmB9iDEZaP1EZinR5Hxg6sgriTc0NjOyMDUxNTYytzQjTVhJnDfp
	YVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBka+c1N63kQbbI5NnVu1O1XuakDr9pybjV+P
	spvVZESsCns1I6tMVVh/SYNuZMmu0iuFh6qSNE5WVMZerI5kyyoT3KL7zEhqnaTT8yXs8Zl/
	MwV8Noa3Otx/o/Vvb9Tsw2lW3jrfTmR/KZssuHqp0vOGyTPmzgr51Sm5eHZDAQ9D68Ujy12O
	rlJiKc5INNRiLipOBACIXP+4EwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQd3c+q/BBrcvallsnLGe1eLg/XqL
	Tdevs1q0XTnIbnF54SVWix+vL7BZ9C64ymZx4WkPm8XZpjdAiV1z2CxmnN/HZLFoWSuzxapd
	fxgdeD12zrrL7nHn2h42j74tqxg9jt/YzuTxeZNcAGtUA6NNRmpiSmqRQmpecn5KZl66rZJ3
	cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtCRSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAa
	I3R9Q4LgeowM0EDCOsaMz89usBSc5at4uPYxUwPjee4uRk4OCQETiaOTFrJB2GISF+6tB7K5
	OIQEpjNKzF/Yzw7h/GaU2HDuNztIFZuAmsSXL4fBbBGBMIldh++CdTALnGSWaDy4CmyUkMB+
	Jonu7iwQm1MgWGLvq5csILawgKfE9kV3mUBsFgFViYVT3jOC2LwCthIH/61lhbAFJX5MvgdW
	zyygLjFp3iJmCFteYvOat0A2B9Cp6hKP/upC3GAk8enORqgSEYl9L94xTmAUmoVk0iwkk2Yh
	mTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGJ5ZnUDsaVDRaHGAU4GJV4eBsW
	fAkWYk0sK67MPcQowcGsJMLr+gsoxJuSWFmVWpQfX1Sak1p8iNEU6NGJzFKiyfnApJdXEm9o
	bGJmZGlkZmFkYm6uJM57oNU6UEggPbEkNTs1tSC1CKaPiYNTqoFRI+5yXmvMtG/LXnG3qHVb
	/8vnrZtSVVJnynLC3/fhvY+9pV7Fj/p7Arufv0zY9VK7ZdqX2w3rHm8tzC+zvaQ/sTvj/oTS
	A6/Wp1+stuQME8hx4d/1QkHk9TwJo9ucom53dt1v216S5xwd3L3Ay8R49beIjqAivai1Vkwi
	a3Z+Y8me/u7S60glluKMREMt5qLiRADllY18QgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 21, 2014 1:31 PM, Vivek Gautam wrote:
> On Mon, Aug 18, 2014 at 4:52 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> > On 18.08.2014 13:02, Bartlomiej Zolnierkiewicz wrote:
> >> On Thursday, August 14, 2014 08:07:40 PM Vivek Gautam wrote:
> >>> On Thursday, August 14, 2014 7:55 PM, Bartlomiej Zolnierkiewicz
> >>> <b.zolnierkie@samsung.com> wrote
> >>
> >>> There's one thing that I would want to comment here, since we don't have any
> >>> new usb-phy driver for S3C64XX,
> >>> so we can't simply remove this entire driver.
> >>> I have posted my patch-series [1], which does cleanup while keeping the
> >>> support for S3C64XX.
> >>
> >> AFAIK S3C64XX code from drivers/usb/phy/phy-samsung-usb2.c has
> >> never been used as this platform still uses its own code from
> >> arch/arm/mach-s3c64xx/setup-usb-phy.c (there are no users in
> >> the kernel tree of either s3c64xx-usb2phy platform device or
> >> "samsung,s3c64xx-usb2phy" DT compatible) .  Therefore I think
> >> that the entire drivers/usb/phy/phy-samsung-usb2.c driver
> >> should be removed (somebody with the hardware can as well add
> >> S3C64XX support to the new drivers/phy/phy-samsung-usb2.c
> >> driver and port the platform to use it).
> >>
> >
> > I agree with removal of this driver. As Bart said, it is not used for
> > S3C64xx at all. The platform was supposed to be moved to this driver,
> > but that never happened.

Yes, right. As far as I know, you're right.

> > In fact, I already have a patch adding support
> > for S3C64xx to the new driver.

Good!

> 
> Cool then, lets remove this driver completely and use the new generic
> PHY based driver
> once that comes (from Tomasz).

I agree with this opinion.

> 
> I shall drop the patches for cleaning up the usb-phy drivers from my series.

Best regards,
Jingoo Han

