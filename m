Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaBGDFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 22:05:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:54708 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaBGDFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 22:05:43 -0500
X-AuditID: cbfee690-b7f266d00000287c-77-52f44d857c96
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Thierry Reding'" <thierry.reding@gmail.com>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Eric Miao'" <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1391518634-6472-1-git-send-email-linus.walleij@linaro.org>
 <000101cf2307$97a3c770$c6eb5650$%han@samsung.com>
 <000001cf230c$60ec1ca0$22c455e0$%han@samsung.com>
 <201402061708.05845.arnd@arndb.de>
In-reply-to: <201402061708.05845.arnd@arndb.de>
Subject: Re: [PATCH] backlight: add PWM dependencies
Date: Fri, 07 Feb 2014 12:05:41 +0900
Message-id: <000d01cf23b1$7c1f8de0$745ea9a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jVaS7w0UfTqHxTdWVZ4mfWjagRgAWAtPQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zA91W3y9BBie361v8nXSM3WJH23E2
	i8sLL7FaTPmznMli0+NrrBaXd81hs7h7dxWjxe3LvBY/d81jceD0aGnuYfP4/WsSo8fOWXfZ
	Pe5c28PmsXlJvUffllWMHp83yQWwR3HZpKTmZJalFunbJXBlzHr2mbVgglDFuhdnmRoYt/J1
	MXJwSAiYSPxeVNvFyAlkiklcuLeerYuRi0NIYBmjxOMXixghEiYSjZ//skIkpjNK3Hv3lAnC
	+cUo8fXJQnaQKjYBNYkvXw6zg0wVEQiQmH9UBaSGWWAyk8SNX6fZIRquMEq8fXQMbCyngL7E
	q8//mEFsYaAVdw//A4uzCKhKXH19GszmFbCVOPjuBDuELSjxY/I9FhCbWUBLYv3O40wQtrzE
	5jVvmSHeUZd49FcX4gYjiW+THCEqRCT2vXgH9Uwvh0TzEWGITQIS3yYfYoHolJXYdIAZokRS
	4uCKGywTGCVmIdk7C8neWUj2zkKyYQEjyypG0dSC5ILipPQiE73ixNzi0rx0veT83E2MkPie
	sIPx3gHrQ4zJQOsnMkuJJucD00NeSbyhsZmRhamJqbGRuaUZacJK4rxqj5KChATSE0tSs1NT
	C1KL4otKc1KLDzEycXBKNTDOj32wlCvFc1Xr2iU31f/Ebongb7o7b9KLoO2m36S4DPSco26q
	sX+Ji3kV0ye2rVd0ddGBqMcOKwwm/lZbUxdXE/0xMVxZxyzThYGxr2Heo8kXzJkWFUx93aT4
	oaF24erCqjeS7s9PWllGPbf84vVW4l2AlMl+qwP9K91K5/9+JvUu3P2TWr8SS3FGoqEWc1Fx
	IgBX50ecBQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsVy+t9jQd1W3y9BBq+Pa1n8nXSM3WJH23E2
	i8sLL7FaTPmznMli0+NrrBaXd81hs7h7dxWjxe3LvBY/d81jceD0aGnuYfP4/WsSo8fOWXfZ
	Pe5c28PmsXlJvUffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxjzJj17DNrwQShinUvzjI1MG7l62Lk5JAQMJFo/PyXFcIWk7hwbz1bFyMXh5DAdEaJe++e
	MkE4vxglvj5ZyA5SxSagJvHly2Egm4NDRCBAYv5RFZAaZoHJTBI3fp1mh2i4wijx9tExRpAG
	TgF9iVef/zGD2MJA6+4e/gcWZxFQlbj6+jSYzStgK3Hw3Ql2CFtQ4sfkeywgNrOAlsT6nceZ
	IGx5ic1r3jKDLJYQUJd49FcX4gYjiW+THCEqRCT2vXjHOIFRaBaSQbOQDJqFZNAsJC0LGFlW
	MYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQnkGdSOxhXNlgcYhTgYFTi4T2x9HOQEGtiWXFl
	7iFGCQ5mJRFeX7kvQUK8KYmVValF+fFFpTmpxYcYk4H+nMgsJZqcD0xueSXxhsYmZkaWRmYW
	Ribm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAyMVZJpOTrube2dW44JyD0+Nrabav
	Hnxccn+hB//xX2VWF+U6Sr0slry//2nevQvcK2QD5kjfY1PbW8IbuujhHd/VAqtWPvJqXO37
	dB+jd8yfx7J7UnNeTp99jY1js+ZaVf6tv2WC5icy58ssFZmk+3rKj/vztZc6C+19kXOrVuuO
	0b+HS2S5JyuxFGckGmoxFxUnAgBxg8N/ZAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 07, 2014 1:08 AM, Arnd Bergmann wrote:
> On Thursday 06 February 2014, Jingoo Han wrote:
> > In the case of "CONFIG_HAVE_PWM=y && CONFIG_PWM=n", it makes
> > the problem.
> >
> > The HAVE_PWM symbol is only for legacy platforms that provide
> > the PWM API without using the generic framework. PXA looks to
> > use the generic PWM framework. Then, how about removing
> > "select HAVE_PWM" from PXA as below?
> >
> 
> I think this is correct, but we may need additional patches. I notice
> that INPUT_MAX8997_HAPTIC and INPUT_PWM_BEEPER have a dependency on
> HAVE_PWM at the moment, so those two drivers become impossible
> to select after your change.
> 
> There is also one use of HAVE_PWM outside of PXA, for ARCH_LPC32XX.
> This one seems to have the same problem.

I looked at all HAVE_PWMs in the latest mainline kernel 3.14-rc1.

1. ARM - PXA
  ./arch/arm/mach-pxa/Kconfig

2. ARM - NXP LPC32XX
  ./arc ARM - PXA h/arm/Kconfig
  config ARCH_LPC32XX
  	select HAVE_PWM

3. MIPS - Ingenic JZ4740 based machines
  ./arch/mips/Kconfig
  config MACH_JZ4740
  	select HAVE_PWM

However, the legacy PWM drivers for PXA, LPC32XX, and JZ474 were
already moved to the generic PWM framework.
  ./drivers/pwm/pwm-pxa.c
  ./drivers/pwm/pwm-lpc32xx.c
  ./drivers/pwm/pwm-jz4740.c

In conclusion, HAVE_PWM should be removed, because HAVE_PWM is
NOT required anymore.

How about the following?

  [PATCH 1/7] ARM: pxa: don't select HAVE_PWM
  [PATCH 2/7] ARM: lpc32xx: don't select HAVE_PWM
  [PATCH 3/7] ARM: remove HAVE_PWM config option
  [PATCH 4/7] MIPS: jz4740: don't select HAVE_PWM
  [PATCH 5/7] Input: max8997_haptic: remove HAVE_PWM dependencies
  [PATCH 6/7] Input: pwm-beepe: remove HAVE_PWM dependencies
  [PATCH 7/7] pwm: don't use IS_ENABLED(CONFIG_HAVE_PWM)

I would like to merge it through PWM tree.
After merging these patches, all HAVE_PWM will be removed from
the mainline kernel. Thank you. :-)

Best regards,
Jingoo Han

> 
> Finally, I have recently encountered a couple of drivers
> (BACKLIGHT_LM3630A, BACKLIGHT_LP855X, BACKLIGHT_LP8788) that use
> the PWM interfaces but are missing a 'depends on PWM'. This is
> strictly speaking a different problem, but we could try to solve
> it at the same time.
> 
> 	Arnd

