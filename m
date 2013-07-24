Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab3GXGtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:49:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27812 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab3GXGtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:49:45 -0400
X-AuditID: cbfee691-b7fef6d000002d62-3c-51ef79064ae2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dongjin Kim'" <tobetter@gmail.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <1374600763-19466-1-git-send-email-tobetter@gmail.com>
 <CAK9yfHz10ao32Y4VRsvjNLe+zaq+hYk4KVgtwFgSLDsN-9Pfpw@mail.gmail.com>
 <CADoNuNdqF0Y=3pdBCE26AQgkv6uqZQ4uE+BfPSSNxAvuuR+kvg@mail.gmail.com>
In-reply-to: <CADoNuNdqF0Y=3pdBCE26AQgkv6uqZQ4uE+BfPSSNxAvuuR+kvg@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: Add USB host node for Exynos4
Date: Wed, 24 Jul 2013 15:49:41 +0900
Message-id: <000001ce8839$f97faa90$ec7effb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIi53KaRmFawk6t3RISskmFGRcqegHZ/1aPAWP4BKqYsLRLYA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+ZgS5b5ftAg0Vr1S0uL7zEatG74Cqb
	xdmmN+wWmx5fY7W4vGsOm8WM8/uYLG5f5rU4/Kad1eLkn15Gi/UzXrNYHJuxhNFi3+M1zA48
	Hi3NPWweO2fdZfe4c20Pm8fmJfUefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlfHxmHDBTcGK
	1++eMDUwLuPpYuTkkBAwkXi0dx8rhC0mceHeerYuRi4OIYFljBITpr9mgSn6dncXO0RiOqPE
	zKMrmCGcX4wSb06/BatiE1CT+PLlMDuILSIQILF63XJWkCJmgSnMEi+v9DBBdFxglLj24iMj
	SBWnQLDE11nnmUFsYQEbicuPt4BNYhFQlXhxpgVsEq+ApcSzrzNYIGxBiR+T74HZzAJaEut3
	HmeCsOUlNq95ywxxq4LEjrOvGSGucJLY+WAVO0SNiMS+F+8YQY6QEJjKIfFl80JGiGUCEt8m
	HwIaygGUkJXYdABqjqTEwRU3WCYwSsxCsnoWktWzkKyehWTFAkaWVYyiqQXJBcVJ6UWmesWJ
	ucWleel6yfm5mxghsT9xB+P9A9aHGJOB1k9klhJNzgemjrySeENjMyMLUxNTYyNzSzPShJXE
	edVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MGr2cUxTeLtIuqp8w96LQUc/+Mh/Unxy
	uvFaA3O1o7WrsdSmiA28WvJXl+zs7fNeXMvh6NAx2+ViyazM5QkXcqfwv9xdUm1TPWND5dfF
	O2emuGx5mW9d+09cYpuea/HaRa2/lkZqei+4enz+s7Y9hfmysvr1jKc3XA3rl8++8+BUDkt3
	b2cZlxJLcUaioRZzUXEiAMQU0IwTAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jQV22yveBBk2LlCwuL7zEatG74Cqb
	xdmmN+wWmx5fY7W4vGsOm8WM8/uYLG5f5rU4/Kad1eLkn15Gi/UzXrNYHJuxhNFi3+M1zA48
	Hi3NPWweO2fdZfe4c20Pm8fmJfUefVtWMXp83iQXwBbVwGiTkZqYklqkkJqXnJ+SmZduq+Qd
	HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SjkkJZYk4pUCggsbhYSd8O04TQEDddC5jG
	CF3fkCC4HiMDNJCwjjHj4zHhgpuCFa/fPWFqYFzG08XIySEhYCLx7e4udghbTOLCvfVsXYxc
	HEIC0xklZh5dwQzh/GKUeHP6LQtIFZuAmsSXL4fBOkQEAiRWr1vOClLELDCFWeLllR4miI4L
	jBLXXnxkBKniFAiW+DrrPDOILSxgI3H58RawSSwCqhIvzrSATeIVsJR49nUGC4QtKPFj8j0w
	m1lAS2L9zuNMELa8xOY1b5khblWQ2HH2NSPEFU4SOx+sYoeoEZHY9+Id4wRGoVlIRs1CMmoW
	klGzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcWJ5J7WBc2WBxiFGAg1GJh7dg
	1rtAIdbEsuLK3EOMEhzMSiK8L2TeBwrxpiRWVqUW5ccXleakFh9iTAb6dCKzlGhyPjDp5ZXE
	GxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QD4+Gnlayh28+0fw/T
	ms9xvE1tQUx/cZDhsdg2vU0Ob6vyUjo2V73l61l2fQtT3K6XrzsVvc9/niWT75DimWTSozrD
	lkG759qq+5HP+3p0+isYnO6+3HX+XaLS5hkxftlWT6bsEnl/pX4ut8e7jdPMPm0Qud23PKf0
	wOKMW0q7bhe9ETNa+ZhRXYmlOCPRUIu5qDgRAJ45krBwAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 24, 2013 3:29 PM, Dongjin Kim wrote:
> 
> +Jingoo Han
> 
> Sorry, its my bad. Typo problem.
> 
> I found another patch same with mine,
> https://patchwork.kernel.org/patch/2628451, submitted by Jingoo Han
> and tested on Exynos4210. Mine is tested on Exynos4412. Both SoC have
> same USB host address space, so I think USB host device nodes can be
> placed in exynos4.dtsi.

OK, USB host device nodes can be placed in exynos4.dtsi.

However, next time, please leave comment on earlier patch.
The patch for Exynos4210 USB was already submitted 2 months ago.


> 
> Regards,
> Dongjin.
> 
> On Wed, Jul 24, 2013 at 12:38 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> > On 23 July 2013 23:02, Dongjin Kim <tobetter@gmail.com> wrote:
> >> This patch adds EHCI and OHCI host device nodes for Exynos4.
> >>
> >> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> >> ---
> >>  arch/arm/boot/dts/exynos4.dtsi |   20 ++++++++++++++++++++
> >>  1 file changed, 20 insertions(+)
> >>
> >> diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
> >> index 3f94fe8..1cdbf89 100644
> >> --- a/arch/arm/boot/dts/exynos4.dtsi
> >> +++ b/arch/arm/boot/dts/exynos4.dtsi
> >> @@ -155,6 +155,26 @@
> >>                 status = "disabled";
> >>         };
> >>
> >> +       ehci@12580000 {
> >> +               compatible = "samsung,exynos4210-ehci";
> >> +               reg = <0x12580000 0x100>;
> >> +               interrupts = <0 70 0>;
> >> +               status = "disabled";
> >> +
> >> +               clocks = <&clock 304>;
> >> +               clock-names = "usbhost";
> >> +       };
> >> +
> >> +       ohci@12590000 {
> >> +               compatible = "samsung,exynos4210-ohci";
> >> +               reg = <0x12580000 0x100>;
> >
> > Register value and node name do not match. Typo?
> >
> >
> >> +               interrupts = <0 70 0>;
> >> +               status = "disabled";
> >> +
> >> +               clocks = <&clock 304>;
> >> +               clock-names = "usbhost";
> >> +       };
> >> +
> >>         mfc: codec@13400000 {
> >>                 compatible = "samsung,mfc-v5";
> >>                 reg = <0x13400000 0x10000>;
> >> --
> >> 1.7.9.5

