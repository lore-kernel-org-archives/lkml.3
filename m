Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaIVMJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 08:09:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26033 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbaIVMJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 08:09:18 -0400
X-AuditID: cbfee68d-f79296d000004278-41-5420116c9d99
From: Kukjin Kim <kgene@kernel.org>
To: "=?UTF-8?Q?'Andreas_F=C3=A4rber'?=" <afaerber@suse.de>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Daniel Drake'" <drake@endlessm.com>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1410954633-27025-1-git-send-email-javier.martinez@collabora.co.uk>
 <1410954633-27025-3-git-send-email-javier.martinez@collabora.co.uk>
 <CAD=FV=W7xJ01m2oLtuDnogOmrpwpztbir=59oSWU6oojFYUWKw@mail.gmail.com>
 <5419ADF9.3010509@suse.de>
In-reply-to: <5419ADF9.3010509@suse.de>
Subject: RE: [PATCH 2/2] ARM: dts: Add rtc_src clk for s3c-rtc on
 exynos5250-snow
Date: Mon, 22 Sep 2014 21:09:15 +0900
Message-id: <01d001cfd65e$0790be30$16b23a90$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLbS3wcopW0Zexicw3nUqbcbogB6QLhhACVAbb1ttEBy1EbVJnDBZWA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zQ90cQYUQg0dbxS2aNxVbXP/ynNXi
	7LKDbBaP5j9mtjj6u8Bi0+NrrBaXd81hs5hxfh+TA4fH7IaLLB5/n19n8Vj0Pctj85J6j74t
	qxg9Np+u9vi8SS6APYrLJiU1J7MstUjfLoEr49TaO+wFM8UrHt6aydTA+Eawi5GTQ0LARGLD
	zNlsELaYxIV764FsLg4hgWWMEos+PmSDKdq6spkVIrGIUeLQ/U6oqr+MEtNnz2XqYuTgYBNQ
	lmhs0gdpEBbQkli4pYkFxBYRSJaYN+MyC0g9s8AEJomtq/YxgiSEBH4ySmz/VwVicwqoS0zb
	epYdojlYYtXKg8wgNouAqsSD57vAruAVsJB42nybFcIWlPgx+R7YAmag3knzFjFD2NoST95d
	YIW4WkFix9nXjBBHuElM7nzHDlEjIrHvxTtGkIMkBDo5JPad3wW1TEDi2+RDLCDPSAjISmw6
	wAwxR1Li4IobLBMYJWchWT0LyepZSFbPQrJiASPLKkbR1ILkguKk9CJDveLE3OLSvHS95Pzc
	TYyQaO/dwXj7gPUhRgEORiUe3gVN8iFCrIllxZW5hxhNgS6ayCwlmpwPTCl5JfGGxmZGFqYm
	psZG5pZmSuK8ilI/g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwmu9IdtY+r3OvaVv8jkV7
	nWYvebdCdQmnkYrBttL+s96SntOkBP4otS86EJMW7OYjonrxW16KeuF7maTmjP0RUuevdx4K
	VH1xOvTD5UNn00T6FRgzc9RnaCWxlLfUnN99uov1ZtjXgKWiGu5KAo0Pf5T/Oq03dUJQv/jE
	M71GQTMcA7MPrbZXYinOSDTUYi4qTgQAvClz2fECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd0cQYUQg9VXhCyaNxVbXP/ynNXi
	7LKDbBaP5j9mtjj6u8Bi0+NrrBaXd81hs5hxfh+TA4fH7IaLLB5/n19n8Vj0Pctj85J6j74t
	qxg9Np+u9vi8SS6APaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
	VsnFJ0DXLTMH6CIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8aptXfY
	C2aKVzy8NZOpgfGNYBcjJ4eEgInE1pXNrBC2mMSFe+vZuhi5OIQEFjFKHLrfCeX8ZZSYPnsu
	UxcjBwebgLJEY5M+SIOwgJbEwi1NLCC2iECyxLwZl1lA6pkFJjBJbF21jxEkISTwk1Fi+78q
	EJtTQF1i2taz7BDNwRKrVh5kBrFZBFQlHjzfxQZi8wpYSDxtvs0KYQtK/Jh8D2wBM1DvpHmL
	mCFsbYkn7y5AXa0gsePsa0aII9wkJne+Y4eoEZHY9+Id4wRG4VlIRs1CMmoWklGzkLQsYGRZ
	xSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcSp5J72Bc1WBxiFGAg1GJh/dHi3yIEGtiWXFl
	7iFGCQ5mJRFeXx6FECHelMTKqtSi/Pii0pzU4kOMpkCfTmSWEk3OB6a5vJJ4Q2MTMyNLIzML
	IxNzcyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFINjKwX1uRNDu0qZ1yxabfAau6ITd6f8xtq
	/B7dPyPcdjLvNEvArZIzclr7gquecTybd+rYYen+eaaMpysCrOs7di48Mnnex8DTYSWz3pRK
	zz4efrP4eXZX2pWm6YdOT749QZXr7OKnx7598v/nIme/k1fsTNm36NAzk413fBXVeerVsSft
	35VZdTOVWIozEg21mIuKEwERlYRwOwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Färber wrote:
> 
> Am 17.09.2014 um 17:47 schrieb Doug Anderson:
> > Hi,
> >
> > On Wed, Sep 17, 2014 at 4:50 AM, Javier Martinez Canillas
> > <javier.martinez@collabora.co.uk> wrote:
> >> commit 546b117fdf17 ("rtc: s3c: add support for RTC of Exynos3250 SoC")
> >> added an "rtc_src" DT property for the Samsung's S3C Real Time Clock
> >> controller that specifies the 32.768 kHz clock that uses the RTC as its
> >> source clock. In the case of the Exynos5250 based Snow board, the Maxim
> >> 77686 32kHz AP clock is used as the source clock.
> >>
> >> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> >> ---
> >>  arch/arm/boot/dts/exynos5250-snow.dts | 5 ++++-
> >>  1 file changed, 4 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> >> index e51fcef..56eec56 100644
> >> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> >> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> >> @@ -10,6 +10,7 @@
> >>
> >>  /dts-v1/;
> >>  #include <dt-bindings/gpio/gpio.h>
> >> +#include <dt-bindings/clock/maxim,max77686.h>
> >>  #include "exynos5250.dtsi"
> >>
> >>  / {
> >> @@ -29,6 +30,8 @@
> >>
> >>         rtc@101E0000 {
> >>                 status = "okay";
> >> +               clocks = <&clock CLK_RTC>, <&max77686 MAX77686_CLK_AP>;
> >> +               clock-names = "rtc", "rtc_src";
> >
> > Wait, seriously?  Snow is still using the "rtc@101E0000" syntax?
> > Whatever happened to the series that Andreas worked so hard on,
> > including <https://patchwork.kernel.org/patch/4664801/>?
> >
> > Kukjin: Andreas's patch series was Reviewed long ago I think and by
> > now I'd imagine it's got some conflicts due to it not having been
> > applied in a timely fashion.  Perhaps you could fix it up for Andreas
> > (since he's already rebased it several times) and land it?
> >
> > If I had to guess, outstanding from Andreas's series (patchwork IDs listed):
> >
> > 4751131 New          [v7] ARM: dts: Prepare node labels for exynos5250
> > 4664801 New          [v6,04/10] ARM: dts: Clean up exynos5250-snow
> > 4664771 New          [v6,05/10] ARM: dts: Fill in bootargs for exynos5250-snow
> > 4664731 New          [v6,06/10] ARM: dts: Clean up exynos5250-smdk5250
> > 4664751 New          [v6,07/10] ARM: dts: Clean up exynos5250-arndale
> > 4664711 New          [v6,08/10] ARM: dts: Fix apparent GPIO typo in
> > exynos5250-arndale
> > 4664681 New          [v6,09/10] ARM: dts: Simplify USB3503 on exynos5250-arndale
> > 4664691 New          [v6,10/10] ARM: dts: Add exynos5250-spring device tree
> 
> Yes, Kukjin told me not to resend anything, and I haven't heard back
> from him since his Kernel Summit trip.
> 
Sorry about that and I thought I took them :( I'll sort them out tonight
including this series together.

- Kukjin

