Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab3LMJZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:25:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:60190 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab3LMJZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:25:00 -0500
X-AuditID: cbfee68f-b7fe36d0000016f8-a8-52aad26b0af3
From: kgene@kernel.org
To: "=?ISO-8859-1?Q?'Jos=E9_Miguel_Gon=E7alves'?=" 
	<jose.goncalves@inov.pt>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>
Cc: "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        "=?ISO-8859-1?Q?'Heiko_St=FCbner'?=" <heiko@sntech.de>
References: <1378889173-7437-1-git-send-email-jose.goncalves@inov.pt>
 <CACRpkdYbCzOJ9k8AyriM9quafx=dseK6w1DYjyrJ9F53ka8TEw@mail.gmail.com>
 <52AA6909.8050200@inov.pt>
In-reply-to: <52AA6909.8050200@inov.pt>
Subject: RE: [PATCH] ARM: S3C24XX: Fix configuration of gpio port sizes on
 S3C24XX.
Date: Fri, 13 Dec 2013 18:24:59 +0900
Message-id: <0bc301cef7e5$319ac0c0$94d04240$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLqz1ngc40HcnnF0yhWSqetU45y9gIKsVVbAUT9t4eX/6x8sA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t8zI93sS6uCDPq7JS3+P3rNavGxaS2T
	xZQ/y5ksNs//w2hxedccNosZ5/cxWayf8ZrFgd3j8fa7TB53ru1h8+jbsorRY/u1ecwenzfJ
	BbBGcdmkpOZklqUW6dslcGUs/rmDtWAid8WaiWINjOc4uhg5OCQETCTezNfpYuQEMsUkLtxb
	z9bFyMUhJLCMUeLsmXPsEAkTiTXzz7FCJBYxSsxrucEI4fxllLi/7h8jyCQ2oPapT6RBGoQF
	tCQWbmliAakREZjNKNHxcDaYwyywnlGi7UgPE0T3SkaJFR1zGEFaOAXUJbpedTNCtIdKLJyy
	Cmw3i4CqxI+G1cwgNq+AhcSTpxtZIGxBiR+T74HZzAI6Evtbp7FB2NoST95dYIW4W0Fix9nX
	YDNFBJwk7v+CmMMsICKx78U7sBckBH6yS1x6+J0JYpmAxLfJh1ggASMrsekAM8QcSYmDK26w
	TGCUnIVk9Swkq2chWT0LyYoFjCyrGEVTC5ILipPSi4z1ihNzi0vz0vWS83M3MUIiu38H490D
	1ocYk4HWT2SWEk3OByaGvJJ4Q2MzIwtTE1NjI3NLM9KElcR57z9MChISSE8sSc1OTS1ILYov
	Ks1JLT7EyMTBKdXAWOp3mOep7sc0LnOLyA4m+/LDrhL9It7si9+vWGbesf7mfGXHiC+Np41n
	3nT32qabEuG/W0RwjZqMWkjo1Dr7+Gt/ldw6Cm54dQvKZnDVai/q3vf41Wy9KP05eke+fhCP
	q/rpeXHF0/rbl2c67z/XuX0lS5O+e7DTyVua4ebO/WeubFqQ7RetxFKckWioxVxUnAgA/Enc
	qAIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsVy+t9jAd3sS6uCDBZeFrH4/+g1q8XHprVM
	FlP+LGey2Dz/D6PF5V1z2CxmnN/HZLF+xmsWB3aPx9vvMnncubaHzaNvyypGj+3X5jF7fN4k
	F8Aa1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0
	h5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY/HPHawFE7kr1kwUa2A8
	x9HFyMkhIWAisWb+OVYIW0ziwr31bF2MXBxCAosYJea13GCEcP4yStxf9w/I4eBgA6qa+kQa
	pEFYQEti4ZYmFpAaEYHZjBIdD2eDOcwC6xkl2o70MEF0r2SUWNExhxGkhVNAXaLrVTcjRHuo
	xMIpq9hBbBYBVYkfDauZQWxeAQuJJ083skDYghI/Jt8Ds5kFdCT2t05jg7C1JZ68uwB1t4LE
	jrOvwWaKCDhJ3P8FMYdZQERi34t3jBMYhWchGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6h
	XnFibnFpXrpecn7uJkZw4ngmtYNxZYPFIUYBDkYlHl6P3lVBQqyJZcWVuYcYJTiYlUR496sD
	hXhTEiurUovy44tKc1KLDzEmA306kVlKNDkfmNTySuINjU3MjCyNzCyMTMzNSRNWEuc90God
	KCSQnliSmp2aWpBaBLOFiYNTqoFxncyZRXy1nfyl6WstnELWXVrilCoWH39bbvk57unlnje5
	bmo8fH95elrMMvtlB8p6lU+q9jvemZ+3MkDC92J0iFvKlq7bgW8t1/T4LVQpmBDAlivYtdhh
	pvXiikR/x3vvFL7Whr+8KmTlq/vhgpkX3+bK4gVxUx6Gvk8IOF1ZxhCZ4f01rVSJpTgj0VCL
	uag4EQDjTbS0YAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

José Miguel Gonçalves wrote:
> 
> On 27-09-2013 15:17, Linus Walleij wrote:
> > On Wed, Sep 11, 2013 at 10:46 AM, José Miguel Gonçalves
> > <jose.goncalves@inov.pt> wrote:
> >
> >> Some GPIO line limits are incorrectly set which, for instance,
> >> does not allow nRTS1 (GPH11) configuration on a S3C2416 chip.
> >>
> >> Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
> >> ---
> >>   arch/arm/mach-s3c24xx/include/mach/gpio.h |   10 +++++-----
> > OK but grrrr!
> >
> > What needs to happen to the s3c24xx is to get rid of this file.
> >
> > - Define ARCH_NR_GPIOS in arch/arm/Kconfig entry
> >    ARCH_NR_GPIO like everyone else
> >
> > - Get rid of the config symbol NEED_MACH_GPIO_H
> >
> > -  Move this file down into arch/arm/mach-s3c24xx/s3c24xx-gpio.h
> >    or whatever and make it local...
> >
> > I will try to do this myself if noone else helps out, so I'd like to
> > carry this patch in the GPIO tree provided I can get an ACK from
> > the S3C24xx maintainer. Tomasz, is that you or Kukjin?
> >
> > (BTW the above maybe goes for S3c64xx as well .. and S5P
> > oh well I will get to it.)
> >
> 
> Was this patch forgotten?
> 
Hi Jose,

Sorry about missing your patch. It's my fault :( and as you know, at this
moment the file will be removed by Linus' patch...

Anyway, let me look at the Samsung patches closely ;)

Thanks,
Kukjin

