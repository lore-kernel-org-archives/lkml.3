Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3FJIfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:35:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47174 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3FJIfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:35:15 -0400
X-AuditID: cbfee68e-b7f276d000002279-d7-51b58fbdf0d9
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Cc: "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Sean Paul'" <seanpaul@chromium.org>,
        "=?ISO-8859-1?Q?'St=E9phane_Marchesin'?=" <marcheu@chromium.org>,
        "'Andrew Bresticker'" <abrestic@chromium.org>
References: <000001ce4e1e$d1cc5de0$756519a0$@samsung.com>
 <CAD=FV=V9oBR1ZAEsMs5-x7NaD1fiHJO=9dn1mPAMg0MX6tnxYA@mail.gmail.com>
In-reply-to: <CAD=FV=V9oBR1ZAEsMs5-x7NaD1fiHJO=9dn1mPAMg0MX6tnxYA@mail.gmail.com>
Subject: RE: [PATCH] ARM: dts: add pin state information for DP HPD support to
 Exynos5250
Date: Mon, 10 Jun 2013 17:35:08 +0900
Message-id: <0ea201ce65b5$6a78ca30$3f6a5e90$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5OkC29mAV/M7XtSq+hZ46zZYxXWwXJScXA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t8zY929/VsDDea/FbFY+f4vo8XZZQfZ
	LC4vvMRqsenxNVaLy7vmsFnMOL+PyWLeod+MFqeuf2azuLvhLKPFsRlLGB24PGY3XGTxuHNt
	D5vH5iX1HldONLF69G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8bdayvYCl4LVDQ8Ws/awPiW
	u4uRk0NCwERi58uZrBC2mMSFe+vZuhi5OIQEljFKbD39gQ2m6NuT1cwQiUWMEru6X7OAJIQE
	/jJK7N9hD2KzCWhIHH7/jB3EFhHwl/h09TRYA7PAGyaJo2ceskJ0NzBKXLl4FaybUyBY4sf8
	HYxdjBwcwgLREj/uMYGEWQRUJRYc7QE7iVfAVmJW62YmCFtQ4sfke2CtzAI6Evtbp7FB2PIS
	m9e8ZQYZIyGgLvHory7EDUYSB5v2sEKUiEjse/GOEeQECYGJHBL9f36xQ+wSkPg2+RALRK+s
	xKYDzBAPS0ocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSkV5yYW1yal66X
	nJ+7iRES5X07GG8esD7EmAy0fiKzlGhyPjBJ5JXEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgk
	kJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMWbGxKT24+YW6eIbGz0ctzze6+6gUNuXd2Zup+PX
	qSGnowWFw2vlptzeajjz3IK7McxKe77XSDTp1YVuYA08PuOMKe+OLx5Hzz7bkVc4t0nC6vny
	47tXf972MywpyXYp/w2T5SYlOW9Xhb/md6pnm2y+JapcsWX6hPNBn+cv8A68MmPx3OMNbEos
	xRmJhlrMRcWJAEfmpa4IAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsVy+t9jAd29/VsDDSY18VusfP+X0eLssoNs
	FpcXXmK12PT4GqvF5V1z2CxmnN/HZDHv0G9Gi1PXP7NZ3N1wltHi2IwljA5cHrMbLrJ43Lm2
	h81j85J6jysnmlg9+rasYvT4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX
	0NLCXEkhLzE31VbJxSdA1y0zB+g0JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYG
	aCBhHWPG3Wsr2ApeC1Q0PFrP2sD4lruLkZNDQsBE4tuT1cwQtpjEhXvr2boYuTiEBBYxSuzq
	fs0CkhAS+MsosX+HPYjNJqAhcfj9M3YQW0TAX+LT1dPMIA3MAm+YJI6eecgK0d3AKHHl4lWw
	bk6BYIkf83cwdjFycAgLREv8uMcEEmYRUJVYcLSHFcTmFbCVmNW6mQnCFpT4MfkeWCuzgI7E
	/tZpbBC2vMTmNW+ZQcZICKhLPPqrC3GDkcTBpj2sECUiEvtevGOcwCg0C8mkWUgmzUIyaRaS
	lgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxglPIM6kdjCsbLA4xCnAwKvHwPvi1JVCI
	NbGsuDL3EKMEB7OSCO+shq2BQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTG95JfGGxiZm
	RpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cAoujf7gNbK9Z+crtySFluk
	Pzutk8PQbs8W8yYf+5zM/xJzDI4z/dy1MiTFuPmIfPiBHd63mFMb2wtYRDl3+ZzpnnE2r2Kx
	tnrdpQczi7Z3ivkpFyYYhaV7F25ScfhW7ZVn/ku3JHrfhGjH4z+61lhtXrhGPW6u59dN3cKs
	z+0+s5rMFT+g916JpTgj0VCLuag4EQDv5g5QZQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> Jingoo,
> 
> On Sat, May 11, 2013 at 1:09 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> > Add pin state information for DP HPD support that requires
> > pin configuration support using pinctrl interface.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> > Tested on Exynos5250
> >
> >  arch/arm/boot/dts/exynos5250-pinctrl.dtsi |    7 +++++++
> >  arch/arm/boot/dts/exynos5250-smdk5250.dts |    3 +++
> >  2 files changed, 10 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> > index d1650fb..e9cdee3 100644
> > --- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> > +++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> > @@ -553,6 +553,13 @@
> >                         samsung,pin-pud = <0>;
> >                         samaung,pin-drv = <0>;
> >                 };
> > +
> > +               dp_hpd: dp_hpd {
> > +                       samsung,pins = "gpx0-7";
> > +                       samsung,pin-function = <3>;
> > +                       samsung,pin-pud = <0>;
> > +                       samaung,pin-drv = <0>;
> > +               };
> >         };
> >
> >         pinctrl@13400000 {
> > diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> > index 3e0c792..d53ea34 100644
> > --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
> > +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> > @@ -224,6 +224,9 @@
> >                 samsung,color-depth = <1>;
> >                 samsung,link-rate = <0x0a>;
> >                 samsung,lane-count = <4>;
> > +
> > +               pinctrl-names = "default";
> > +               pinctrl-0 = <&dp_hpd>;
> 
> I was going to suggest moving this to exynos5250.dtsi but then
> realized that I saw a board recently that used a non-standard HPD pin
> recently!  ...so keeping it in the board file (like you've done) is
> good.
> 
> ...so looks good to me.
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>

Yeah, I agreed with Doug's comment :-)

Applied, thanks.

- Kukjin

