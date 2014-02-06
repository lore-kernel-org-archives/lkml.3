Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbaBFGtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 01:49:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9115 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaBFGtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 01:49:35 -0500
X-AuditID: cbfee68f-b7f156d00000276c-d3-52f3307dd21d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Eric Miao'" <eric.y.miao@gmail.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1391518634-6472-1-git-send-email-linus.walleij@linaro.org>
 <000401cf222f$43263b20$c972b160$%han@samsung.com>
 <CACRpkdbB8LFM0Vu8VRo4niqxwxUdS-c5gmmWaxbUTbnLCLZbMA@mail.gmail.com>
In-reply-to: <CACRpkdbB8LFM0Vu8VRo4niqxwxUdS-c5gmmWaxbUTbnLCLZbMA@mail.gmail.com>
Subject: Re: [PATCH] backlight: add PWM dependencies
Date: Thu, 06 Feb 2014 15:49:33 +0900
Message-id: <000101cf2307$97a3c770$c6eb5650$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8iUE/iqGSybP6uTbyxaFS67OfvHwAtkufw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zA91ag89BBhfeaFnsaDvOZnF54SVW
	iyl/ljNZbHp8jdXi8q45bBZ3765itLh9mdfi5655LA4cHi3NPWweO2fdZfe4c20Pm8fmJfUe
	fVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlbHx5SnWgl1iFa0fb7A0MK4R6mLk5JAQMJE40vKV
	EcIWk7hwbz1bFyMXh5DAMkaJbwva2GGKTsx5zgqRmM4o8fjaFkYI5xejxMa+L0wgVWwCahJf
	vhwG6xAR0JN487WFHaSIWWAKk8SW3hVQ7YcYJV51LwNawsHBKRAssf+WHUiDMNCKu4f/gd3B
	IqAqsfnKQXaQEl4BW4kne2NBwrwCghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGaRcQkBd4tFf
	XYgTjCTWb2xkhygRkdj34h3YzRICjRwSj6c/YIJYJSDxbfIhFoheWYlNB5ghHpaUOLjiBssE
	RolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJJ77dzDePWB9
	iDEZaP1EZinR5HxgOsgriTc0NjOyMDUxNTYytzQjTVhJnPf+w6QgIYH0xJLU7NTUgtSi+KLS
	nNTiQ4xMHJxSDYyFH/oqxZ+4SZvc4I2fkp7ge8bgmHbKoZnbZBWWawoem+K8377DpfNLhO6D
	mA+ySl17/z3o8Hjduo9P7if7E7aWqhW6Eobl80Lnb3x2MvCH9mz2grBLz++bfhPLqFohvSW5
	Mudc1aXlFyQ9/72LTea0zJ4fck1r3fxQ/X2ybjeM7bi/71zB/FyJpTgj0VCLuag4EQAljg3Y
	/QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQd1ag89BBhsWqlnsaDvOZnF54SVW
	iyl/ljNZbHp8jdXi8q45bBZ3765itLh9mdfi5655LA4cHi3NPWweO2fdZfe4c20Pm8fmJfUe
	fVtWMXp83iQXwBbVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk
	4hOg65aZA3SPkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjFj48tTrAW7
	xCpaP95gaWBcI9TFyMkhIWAicWLOc1YIW0ziwr31bF2MXBxCAtMZJR5f28II4fxilNjY94UJ
	pIpNQE3iy5fD7CC2iICexJuvLewgRcwCU5gktvSuYIXoOMQo8ap7GdAsDg5OgWCJ/bfsQBqE
	gdbdPfyPEcRmEVCV2HzlIDtICa+ArcSTvbEgYV4BQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nL
	DFIuIaAu8eivLsQJRhLrNzayQ5SISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4o
	TkrPNdQrTswtLs1L10vOz93ECE4Wz6R2MK5ssDjEKMDBqMTDu2H9pyAh1sSy4spcoFc5mJVE
	eC8+BwrxpiRWVqUW5ccXleakFh9iTAb6cyKzlGhyPjCR5ZXEGxqbmBlZGplZGJmYm5MmrCTO
	e6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY3aZmHpC7Cz/kEkS8mKTXk6vnrc5wmJeq8r8lDvd
	qtohFqUqZflTSm4mHT46LeZARnOp/ef/bgfmmZ9915zCfPnwjAUuYgXzuqZydMnIzsr78Wbn
	nyuJDjXV2x98W/vz7w/xLYWG3rfWbw+99u3TomeTA159faCw+X31qoMffjJtORfy1b8xslyJ
	pTgj0VCLuag4EQBfa9iZWgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 05, 2014 5:58 PM, Linus Walleij wrote:
> On Wed, Feb 5, 2014 at 6:01 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> > On Tuesday, February 04, 2014 9:57 PM, Linus Walleij wrote:
> >>
> >> In some compilations the LM3630A and LP855X backlight drivers
> >> fail like this:
> >>
> >> drivers/built-in.o: In function `lm3630a_pwm_ctrl':
> >> drivers/video/backlight/lm3630a_bl.c:168: undefined reference to `pwm_config'
> >> drivers/video/backlight/lm3630a_bl.c:172: undefined reference to `pwm_disable'
> >> drivers/video/backlight/lm3630a_bl.c:170: undefined reference to `pwm_enable'
> >> drivers/built-in.o: In function `lp855x_pwm_ctrl':
> >> drivers/video/backlight/lp855x_bl.c:249: undefined reference to `pwm_config'
> >> drivers/video/backlight/lp855x_bl.c:253: undefined reference to `pwm_disable'
> >> drivers/video/backlight/lp855x_bl.c:251: undefined reference to `pwm_enable'
> >>
> >> This is because both drivers depend on the PWM framework, so
> >> add this dependency to their Kconfig entries.
> >
> > However, even though, when CONFIG_PWM is not enabled, the problem
> > should not happen. pwm_config(),pwm_disable(), and pwm_enable()
> > are already defined for CONFIG_PWM=n case as below.
> 
> So you may think but it does happen :-)
> 
> I reproduced this with the defconfig for ARM pxa255-idp and enabling
> all boards for that platform, then enabling all available backlight drivers
> as compiled-in objects (y).

However, I cannot reproduce it with mainline kernel 3.14-rc1.

1. make pxa255-idp_defconfig
2. Enabling all boards
   (System Type -> Intel PXA2xx/PXA3xx Implementations -> ...)
3. Enabling all available backlight drivers as compiled-in objects (y)

In this case, the LM3630A and LP855X backlight drivers are compiled
properly as below:

  drivers/video/backlight/lm3630a_bl.o
  drivers/video/backlight/lp855x_bl.o

Would you check it with mainline kernel 3.14-rc1?
If the errors happen, please attach the .config file.

Best regards,
Jingoo Han

> 
> > ./include/linux/pwm.h
> > #if IS_ENABLED(CONFIG_PWM) || IS_ENABLED(CONFIG_HAVE_PWM)
> >         .....
> > #else
> 
> Hm PXA that I am using defines CONFIG_HAVE_PWM, but doesn't
> provide the required signatures (pwm_config/pwm_disable/pwm_enable).
> 
> One of two things is wrong:
> 
> - Either the PXA platform is breaking the CONFIG_HAVE_PWM
>   contract by not providing pwm_config/pwm_disable/pwm_enable
>   functions. Then HAVE_PWM should be removed from the PXA
>   Kconfig selects.
> 
> Or:
> 
> - There is no such contract that these functions must exist if
>   CONFIG_HAVE_PWM is defined, and the
>   #if IS_ENABLED(CONFIG_HAVE_PWM)
>   should be removed from <linux/pwm.h>
> 
> Does anyone know which one it is?
> 
> PWM subsystem maintainer? :-)
> 
> Yours,
> Linus Walleij

