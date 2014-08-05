Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaHEMRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:17:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23956 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaHEMQ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:16:59 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-9e-53e0cb38c0a0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "=?UTF-8?Q?'Andreas_F=C3=A4rber'?=" <afaerber@suse.de>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        "'Stephan van Schaik'" <stephan@synkhronix.com>,
        "'Vincent Palatin'" <vpalatin@chromium.org>,
        "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>
 <1406868897-26874-6-git-send-email-afaerber@suse.de>
 <CAD=FV=WhocoyQ=rU7dU1EPM-PAQq06gg9HhamSOm+BgMDeM8NA@mail.gmail.com>
 <53DBFE8A.7020505@suse.de> <53DBFF22.3010905@gmail.com>
In-reply-to: <53DBFF22.3010905@gmail.com>
Subject: Re: [PATCH v5 05/10] ARM: dts: Move dp_hpd from exynos5250 into
 smdk5250 and snow
Date: Tue, 05 Aug 2014 21:16:55 +0900
Message-id: <000e01cfb0a7$25d0ed70$7172c850$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+tyyzhL+02hZwKRRCceQe+lh/WpQC1OnyQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t8zQ12L0w+CDaYc57Bo3lRsMWndASaL
	+UfOsVqcXXaQzaL/zUJWi3OvVjJaHP1dYHF54SVWi94FV9ksNj2+xmpxedccNosZ5/cxWdy+
	zGux9PpFJosJ09eyWLTuPcJusf/YT0aL9TNes1is2vWH0WLbtzssDiIea+atYfRoae5h85jd
	cJHF43JfL5PH3+fXWTz+rnrB7LFz1l12j5XLv7B5bFrVyeaxeUm9R9+WVYwem09Xezxdd5jd
	4/MmuQC+KC6blNSczLLUIn27BK6M838OsBbsUK7ou3+evYFxiVQXIyeHhICJxPSP65khbDGJ
	C/fWs4HYQgLLGCX+7vaHqdmwtZG9i5ELKD6dUWLWj8ssEM5vRokDt04wglSxCahJfPlyGKxK
	RKCHUeLDqcMsIAlmgUusEufeCEF0/GCUeDOxD2wHp4CmxOO+s6wgtrBAjMSUlyeBbA4OFgFV
	icY+QZAwr4CtxK+tt1kgbEGJH5PvQc1Ul5g0bxEzhK0t8eTdBbBWCaD4o7+6IGERASOJCWuP
	MkKUiEjse/GOEeQECYF2Tokl26+wgyRYBAQkvk0+xALRKyux6QA0JCQlDq64wTIB6Fckm2ch
	2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRGSkHp3MN4+YH2IMRlo/URm
	KdHkfGBCyyuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8UWlOavEhRiYO
	TqkGxjWcs0o+6vBzxe48EilX9KLN555GyE394uB3biqnbhqqJQstum5nVesV8Uj4Yf7crOlH
	Nqo2/T15VH7L4XmfjZc6NDbEsx5+fGlj3W2pFGf5+yfT1s3Iyb9wVW2+l7nO3zs7yv7YPVkg
	ydrNu3f3Al3zVeV34rcxfXhscCW66xzvZ9ftR024/iuxFGckGmoxFxUnAgCbfrTxXgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsVy+t9jQV2L0w+CDQ4tZbJo3lRsMWndASaL
	+UfOsVqcXXaQzaL/zUJWi3OvVjJaHP1dYHF54SVWi94FV9ksNj2+xmpxedccNosZ5/cxWdy+
	zGux9PpFJosJ09eyWLTuPcJusf/YT0aL9TNes1is2vWH0WLbtzssDiIea+atYfRoae5h85jd
	cJHF43JfL5PH3+fXWTz+rnrB7LFz1l12j5XLv7B5bFrVyeaxeUm9R9+WVYwem09Xezxdd5jd
	4/MmuQC+qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23
	zBygh5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGef/HGAt2KFc0Xf/
	PHsD4xKpLkZODgkBE4kNWxvZIWwxiQv31rN1MXJxCAlMZ5SY9eMyC4Tzm1HiwK0TjCBVbAJq
	El++HGYHSYgI9DBKfDh1mAUkwSxwiVXi3BshiI4fjBJvJvaxgSQ4BTQlHvedZQWxhQViJKa8
	PAlkc3CwCKhKNPYJgoR5BWwlfm29zQJhC0r8mHwPaqa6xKR5i5ghbG2JJ+8ugLVKAMUf/dUF
	CYsIGElMWHuUEaJERGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJu
	cWleul5yfu4mRnDCeya1g3Flg8UhRgEORiUeXgG1+8FCrIllxZW5hxglOJiVRHif7noQLMSb
	klhZlVqUH19UmpNafIjRFOjPicxSosn5wGScVxJvaGxiZmRpZGZhZGJuriTOe6DVOlBIID2x
	JDU7NbUgtQimj4mDU6qBMajx3vbVDx/o2TgKJyY+TjizIFRvpcP2BwFiirH8WmflbubZP711
	4B3DKa+SrJZVOdMy2Tcd3rDSsF3s2gd9Po15k/IO5F24cyq2iLOj6X/qQzm7sy4bzTZb6n/r
	/W418W7Lx2PrOzwWOa90eLLsMvuTFOa9rn/S5K8l86yyLqoy1Z3J/TYwXImlOCPRUIu5qDgR
	ALM9oVOOAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 02, 2014 5:57 AM, Tomasz Figa wrote:
> On 01.08.2014 22:54, Andreas Färber wrote:
> > Am 01.08.2014 22:33, schrieb Doug Anderson:
> >> On Thu, Jul 31, 2014 at 9:54 PM, Andreas Färber <afaerber@suse.de> wrote:
> >>> Spring uses a different GPIO, so this is not a generic SoC piece.
> >>>
> >>> Suggested-by: Tomasz Figa <t.figa@samsung.com>
> >>> Signed-off-by: Andreas Färber <afaerber@suse.de>
> >>> ---
> >>>  v5: New (Tomasz Figa)
> >>>  Frees dp_hpd for Spring.
> >>>
> >>>  arch/arm/boot/dts/exynos5250-pinctrl.dtsi | 7 -------
> >>>  arch/arm/boot/dts/exynos5250-smdk5250.dts | 9 +++++++++
> >>>  arch/arm/boot/dts/exynos5250-snow.dts     | 7 +++++++
> >>>  3 files changed, 16 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> >>> index 886cfca044ac..ed0e5230514b 100644
> >>> --- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> >>> +++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> >>> @@ -581,13 +581,6 @@
> >>>                         samsung,pin-pud = <0>;
> >>>                         samsung,pin-drv = <0>;
> >>>                 };
> >>> -
> >>> -               dp_hpd: dp_hpd {
> >>> -                       samsung,pins = "gpx0-7";
> >>> -                       samsung,pin-function = <3>;
> >>> -                       samsung,pin-pud = <0>;
> >>> -                       samsung,pin-drv = <0>;
> >>> -               };
> >>>         };
> >>>
> >>>         pinctrl@13400000 {
> >>> diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> >>> index aaa055ac0fe3..5d30fe1dcda4 100644
> >>> --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
> >>> +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> >>> @@ -414,3 +414,12 @@
> >>>                 };
> >>>         };
> >>>  };
> >>> +
> >>> +&pinctrl_0 {
> >>> +       dp_hpd: dp_hpd {
> >>> +               samsung,pins = "gpx0-7";
> >>> +               samsung,pin-function = <3>;
> >>> +               samsung,pin-pud = <0>;
> >>> +               samsung,pin-drv = <0>;
> >>> +       };
> >>> +};
> >>> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> >>> index c4b0c73c736d..a9a2f2743794 100644
> >>> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> >>> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> >>> @@ -547,6 +547,13 @@
> >>>  };
> >>>
> >>>  &pinctrl_0 {
> >>> +       dp_hpd: dp_hpd {
> >>> +               samsung,pins = "gpx0-7";
> >>> +               samsung,pin-function = <3>;
> >>> +               samsung,pin-pud = <0>;
> >>> +               samsung,pin-drv = <0>;
> >>> +       };
> >>> +
> >>
> >> NAK.  dp_hpd is a generic SoC piece.  Pin function 0 and 1 are GPIOs.
> >> Pin function 3 is special function.  This pin _is_ the hot plug detect
> >> pin for display port.  When it's set as special function 3 it goes
> >> straight into the hot plug logic of the display port controller.
> >>
> >> Spring may have had its reasons to detect hot plug events on a GPIO
> >> instead of using this pin, but that doesn't make this pin any less the
> >> "hot plug pin".
> >
> > Please advise how to handle it then: Should there be two different
> > pinctrl entries (if so, how should it be named?),
> 
> IMHO this is the right way. Just name the GPIO variant dp_hpd_gpio.

Hi Andreas Färber,

I agree with Tomasz Figa and Doug Anderson.
Please refer to the following.

1. case: Standard HPD pin is used. (smdk5420)
arch/arm/boot/dts/exynos5420-pinctrl.dts
	pinctrl@13400000 {
		dp_hpd: dp_hpd {
			samsung,pins = "gpx0-7";
			samsung,pin-function = <3>;
			samsung,pin-pud = <0>;
			samsung,pin-drv = <0>;
		};
arch/arm/boot/dts/exynos5420-smdk5420.dts
	dp-controller@145B0000 {
		pinctrl-names = "default";
		pinctrl-0 = <&dp_hpd>;
		...

2. case: non-standard HPD pin such as GPIO is used. (peach pit)
arch/arm/boot/dts/exynos5420-peach-pit.dts
	pinctrl@13400000 {
		dp_hpd_gpio: dp_hpd_gpio {
			samsung,pins = "gpx2-6";
			samsung,pin-function = <0>;
			samsung,pin-pud = <3>;
			samsung,pin-drv = <0>;
		};
	dp-controller@145B0000 {
		pinctrl-names = "default";
		pinctrl-0 = <&dp_hpd_gpio>;
		...
		samsung,hpd-gpio = <&gpx2 6 0>;

So, you need to follow the second case.
"dp_hpd_gpio" can be used for Spring board.

Best regards,
Jingoo Han

