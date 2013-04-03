Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626Ab3DCBqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:46:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28279 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760201Ab3DCBqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:46:18 -0400
X-AuditID: cbfee690-b7f656d0000007e3-34-515b89e1038d
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vivek Gautam'" <gautamvivek1987@gmail.com>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Olof Johansson'" <olof@lixom.net>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Padmavathi Venna'" <padma.v@samsung.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1363195099-15919-1-git-send-email-dianders@chromium.org>
 <006301ce211d$a6caa670$f45ff350$%han@samsung.com>
 <CAFp+6iFXd-4uFfc4v_kWf_FTBmeHkNwsEV0QoyHCzza8evgd9A@mail.gmail.com>
In-reply-to: <CAFp+6iFXd-4uFfc4v_kWf_FTBmeHkNwsEV0QoyHCzza8evgd9A@mail.gmail.com>
Subject: RE: [PATCH] ARM: dts: add usb 2.0 clock references to exynos5250
 device tree
Date: Wed, 03 Apr 2013 10:46:08 +0900
Message-id: <24ae01ce300d$037af160$0a70d420$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4j3l9d+Bt6rJ26RWixeCnyK/nUPQMLnBKA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+Zke7DzuhAg4MPhS3+zT7FZnF22UE2
	i7YrB9kt3n7fwm5xeeElVotNj6+xWlzeNYfN4vZlXotT1z+zWfy++Z3N4tiMJYwO3B4tzT1s
	HrMbLrJ47Jx1l93jzrU9bB6bl9R7XDnRxOrxcuJvNo++LasYPT5vkgvgjOKySUnNySxLLdK3
	S+DKOPPzOHvBK96KqZ9eszcwfuPsYuTkkBAwkTixYQsbhC0mceHeejBbSGAZo0Tnf5suRg6w
	mm03fboYuYDCixglfky7wQ7h/GWUeHP8MjNIA5uAhsTh98/YQWwRgUiJZ9t62ECKmAV+M0ls
	f94F1XGAUWLrwhusIFWcAsESM++uZwdZISwQLvGqDewiFgFViYMrzoEN5RWwlei5840FwhaU
	+DH5HpjNLKAlsX7ncSYIW15i85q3zBCXqks8+qsLYooIGElM2iwPUSEise/FO0aQCyQElnJI
	nG/+xwaxSkDi2+RDLBCtshKbDjBDwkES6IIbLBMYJWYhWTwLyeJZSBbPQrJiASPLKkbR1ILk
	guKk9CITveLE3OLSvHS95PzcTYyQNDBhB+O9A9aHGJOB1k9klhJNzgemkbySeENjMyMLUxNT
	YyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MBZ2GZsIun/e6WR4Tvi2
	oOPUdbsPJ0dFOkeKThX7F/tZqyg3N7F41YUbj5jDPxe6bBP1tpAwnPtiTgzPVqvIn3/37/NS
	t3gQMd8hMWNy7Ou373dyZreqOzontJpYn8qbmtZxWH1+2Y5be4SXWlgX/396xffrwsUsEs+v
	JU04eHPj4pSXOXtuTlBiKc5INNRiLipOBACig0gJGQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsVy+t9jAd2HndGBBodP8Vn8m32KzeLssoNs
	Fm1XDrJbvP2+hd3i8sJLrBabHl9jtbi8aw6bxe3LvBanrn9ms/h98zubxbEZSxgduD1amnvY
	PGY3XGTx2DnrLrvHnWt72Dw2L6n3uHKiidXj5cTfbB59W1YxenzeJBfAGdXAaJORmpiSWqSQ
	mpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdK2SQlliTilQKCCxuFhJ
	3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePMz+PsBa94K6Z+es3ewPiNs4uRg0NCwERi202f
	LkZOIFNM4sK99WxdjFwcQgKLGCV+TLvBDuH8ZZR4c/wyM0gVm4CGxOH3z9hBbBGBSIln23rA
	OpgFfjNJbH/eBdVxgFFi68IbrCBVnALBEjPvrmcHWScsEC7xqo0TJMwioCpxcMU5sKG8ArYS
	PXe+sUDYghI/Jt8Ds5kFtCTW7zzOBGHLS2xe85YZ4mp1iUd/dUFMEQEjiUmb5SEqRCT2vXjH
	OIFRaBaSQbOQDJqFZNAsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSnmWdSOxhX
	NlgcYhTgYFTi4T3xJSpQiDWxrLgy9xCjBAezkgjv6bDoQCHelMTKqtSi/Pii0pzU4kOMyUB/
	TmSWEk3OB6bAvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpg
	XOq7wf7zjHdVi3ks/mwpZOyxnHlh3tSi58o3Lu6PWsVQHzvzTOOmAI5HwRLz7A13XjDiEDq2
	Iyvj89eA6DcrLu40ucoY8jmboebnnR1bG/WF0vqDXpv7/1XPbL92hdNIb2XHou/iCQrz+G78
	X3hXv/bBpXKrBIeP4V/EfguwWnooZ3GdFxR/osRSnJFoqMVcVJwIAGJUuYF3AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Gautam wrote:
> 
> Hi,
> 
> 
> On Fri, Mar 15, 2013 at 7:07 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> >
> > On Thursday, March 14, 2013 2:18 AM, Doug Anderson wrote:
> >>
> >> This is a fixup to two device tree nodes that have already landed but
> >> without clock nodes since the transition to common clock happened at
> >> the same time.
> >>
> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> >
> > The clock number and name are right.
> >
> > Reviewed-by: Jingoo Han <jg1.han@samsung.com>
> >
> >
> > Best regards,
> > Jingoo Han
> >
> >> ---
> >>  arch/arm/boot/dts/exynos5250.dtsi | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
> b/arch/arm/boot/dts/exynos5250.dtsi
> >> index 24c52e6..59be603 100644
> >> --- a/arch/arm/boot/dts/exynos5250.dtsi
> >> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> >> @@ -402,12 +402,18 @@
> >>               compatible = "samsung,exynos4210-ehci";
> >>               reg = <0x12110000 0x100>;
> >>               interrupts = <0 71 0>;
> >> +
> >> +             clocks = <&clock 285>;
> >> +             clock-names = "usbhost";
> >>       };
> >>
> >>       usb@12120000 {
> >>               compatible = "samsung,exynos4210-ohci";
> >>               reg = <0x12120000 0x100>;
> >>               interrupts = <0 71 0>;
> >> +
> >> +             clocks = <&clock 285>;
> >> +             clock-names = "usbhost";
> 
> tested this patch with smdk5250 h/w.
> 
> Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> 
Vivek and Jingoo,

Thanks for your review and test.

Looks good to me and I applied in my local.
Just note that this should be seen in my public tree tomorrow night(KST).

- Kukjin

