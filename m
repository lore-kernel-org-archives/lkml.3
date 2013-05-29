Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965442Ab3E2JdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:33:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9637 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965381Ab3E2JdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:33:04 -0400
X-AuditID: cbfee68f-b7f436d000000f81-39-51a5cb4e87b2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tushar Behera'" <tushar.behera@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, "'Kevin Hilman'" <khilman@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Patch Tracking'" <patches@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>
References: <1368168599-28507-1-git-send-email-tushar.behera@linaro.org>
 <87sj1qzaov.fsf@linaro.org> <5191AA89.6010901@linaro.org>
 <20130528231740.GA28879@quad.lixom.net> <51A57D39.8030506@linaro.org>
 <CAOesGMh50Dzr_jczHZC5_txfW=6a+7EgFKvgZgj9MhUcVUTJ1Q@mail.gmail.com>
 <51A5C16D.20408@linaro.org>
In-reply-to: <51A5C16D.20408@linaro.org>
Subject: Re: [PATCH] ARM: EXYNOS: Update defconfig for Arndale and Origen board
Date: Wed, 29 May 2013 18:33:01 +0900
Message-id: <000001ce5c4f$839f4cb0$8adde610$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIU7nTg5yYSnFMzgDE9nqE+1HD1bgFvVSYoAdTiqN8CaMaKbwMHW2GEAh1I9CECd4Dp0Zgkcl0Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+Zsa7f6aWBBjtPiFn8nXSM3eLssoNs
	Fm1XDrJbXF54idWid8FVNouvh1cwWmx6fI3V4vKuOWwWM87vY7I4df0zm8WUw19YLI7NWMJo
	0f53L5sDr8fvX5MYPWY3XGTxuHNtD5vH5iX1HldONLF69G1ZxejxeZNcAHsUl01Kak5mWWqR
	vl0CV8a/F/uYC9bKVfyf1cfcwPhfvIuRk0NCwETixtonbBC2mMSFe+uBbC4OIYFljBKHVk9i
	gym6t34LM0RiOqPEoxcnGCGcX4wSDxsvMYJUsQmoSXz5cpgdxBYRCJY4+PEPO0gRs8AaZomd
	T+5CdWxkkvgwbw4rSBWngIbEh52/wTqEBfwlbnyfxQxiswioSvyd2Qk2lVfAUmLFuufsELag
	xI/J91hAbGYBLYn1O48zQdjyEpvXvGWGuFVBYsfZ14wQV8RI3Fp+hg2iRkRi34t3YEdICKzk
	kPj2aAsbxDIBiW+TDwEN5QBKyEpsOgA1R1Li4IobLBMYJWYhWT0LyepZSFbPQrJiASPLKkbR
	1ILkguKk9CJjveLE3OLSvHS95PzcTYyQlNC/g/HuAetDjMlA6ycyS4km5wNTSl5JvKGxmZGF
	qYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGGVelgatNfXV5lvP
	yW0fILD+ZtlURpVEfzfbiSWv6xz/qb90FmyqKhad4blSusiUzUR6hWPeo3m77/Zwboo7PvPC
	2/NrGE/8OKHc8VFl4jL3Jz9qfpv6PXISuX/w6axFnKkzDnL1abQltq+Q2dbmeEi71nuxaFvr
	qVk7Qie0RbRVrd3vu1feUImlOCPRUIu5qDgRANSyUi0fAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t9jQV2/00sDDeb8F7D4O+kYu8XZZQfZ
	LNquHGS3uLzwEqtF74KrbBZfD69gtNj0+BqrxeVdc9gsZpzfx2Rx6vpnNosph7+wWBybsYTR
	ov3vXjYHXo/fvyYxesxuuMjicefaHjaPzUvqPa6caGL16NuyitHj8ya5APaoBkabjNTElNQi
	hdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKBzlRTKEnNKgUIBicXF
	Svp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZ/17sYy5YK1fxf1YfcwPjf/EuRk4OCQETiXvr
	tzBD2GISF+6tZ+ti5OIQEpjOKPHoxQlGCOcXo8TDxkuMIFVsAmoSX74cZgexRQSCJQ5+/MMO
	UsQssIZZYueTu1AdG5kkPsybwwpSxSmgIfFh52+wDmEBf4kb32eB7WMRUJX4O7MTbCqvgKXE
	inXP2SFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3kLdauCxI6zrxkhroiRuLX8DBtEjYjEvhfv
	GCcwCs1CMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzghPNMegfj
	qgaLQ4wCHIxKPLwBX5cECrEmlhVX5h5ilOBgVhLhTRVcGijEm5JYWZValB9fVJqTWnyIMRno
	04nMUqLJ+cBkmFcSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFIN
	jIxrJ2wTXtE+MXTNS0PnRytVN72pCG5bqf/o3+2DXz/vlX552e1e5+Eyk6VTXrBa961MVfnv
	sm7l3P89izTmaNzcsud2LU9kN5d3v9hsCyXO6qdua+zM3UweKGTFfBFdv8RnX7TC4slVTZv9
	V2w9f0q6dKNAxtJZDpXWPzmDPjYfMDtx6Ez/BmElluKMREMt5qLiRABBLaU9fAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 29, 2013 5:51 PM, Tushar Behera:
> On 05/29/2013 11:01 AM, Olof Johansson wrote:
> > On Tue, May 28, 2013 at 8:59 PM, Tushar Behera <tushar.behera@linaro.org> wrote:
> >
> >> The patches are at [1].
> >
> > FWIW, a cgit/gitweb link is easier to follow when you're reading an
> > email. Anyway, found the patches.
> >
> >> There are a total of 6 patches on top of
> >> v3.10-rc3. 3 of them (a, b, d) are queued for 3.10-rc4 and another patch
> >> (c) is just a defconfig hack to get Arndale booting. Remaining 2 patches
> >> (e, f) are required to reset the hub during EHCI initialization.
> >
> > Huh, I thought you said that (c) wasn't needed when I posted the
> > defconfig update. It'd be nice to see the code fixed to handle this
> > case instead of Linaro carrying a patch like this though. I.e. make it
> > able to deselect the uart, or make it tied to DEBUG_LL like on other
> > platforms instead of having a separate config for this.
> >
> 
> It would be good to free up the dependency on the correct UART port for
> the board to boot. Without that, there would always be boards that don't
> boot with default mainline defconfig file even though all other
> components are in place.
> 
> >> a. ARM: exynos: defconfig update
> >> b. ARM: EXYNOS: Update defconfig for Arndale and Origen board
> >> c. [TEMP] ARM: EXYNOS: Set low-level UART port to 2
> >> d. ARM: dts: Enabling samsung-usb2phy driver for exynos5250
> >> e. usb: ehci-s5p: add the HSIC port initialization
> >> f. ARM: dts: Add USB gpio entries for Arndale board
> >>
> >> I am not sure whether such kind of board-specific patches (e, f) are
> >> appreciated in the drivers. But that is all we need to get USB and
> >> Ethernet to work on v3.10-rc3 kernel.
> >
> > I've come across a similar situation with wifi reset sequence on the
> > chromebook. On the product kernel we added some code to the board file
> > to deal with it, but if we keep doing that things will grow out of
> > hand.
> >
> > I don't know if it'll be unpopular, but I think it's time to start a
> > drivers/platform/arm for these kind of things, and have those drivers
> > probe on the system compatible value, similar to how x86 does it (with
> > DMI tables). At least that's my plan for approaching the wifi
> > reset/power-on sequence on the Chromebook. I hope to have patches in
> > not all that long...
> >
> > Likewise, the hub reset/enable code doesn't have to go with the USB
> > driver, right? I.e. if you cycle reset/enable on the hub after the
> > host and phy is configured, you'll still have a working setup?
> >
> 
> Right, hub reset/enable code need not be tied up with USB driver. As per
> your suggestion regarding drivers/platform/arm, I implemented an Arndale
> specific driver [2] in drivers/platform/arm and verified USB and
> ethernet to be working.

CC'ed Thomas Abraham, Vivek Gautam

I think so.

I looked at Arndale board Schematics.
'Hub chip' on Arndale board needs hub reset/enable code.
'HUB_RESET' and 'HUB_CONNECT' pins are used to reset 'Hub chip'
on Arndale board, not Exynos EHCI controller. So, Exynos EHCI driver
does not need to consider this hub reset/enable code.

If there is a driver for this 'Hub chip', 'Hub chip' driver maybe
consider this.

However, Olof Johansson mentioned, 'drivers/platform/arm/board_arndale.c'
would be a good alternative.

> 
> [2]
> https://git.linaro.org/gitweb?p=landing-
> teams/working/samsung/kernel.git;a=shortlog;h=refs/heads/upstream/arndale-usb-2

It looks good.

Best regards,
Jingoo Han

> 
> >
> > -Olof
> >
> 
> 
> --
> Tushar Behera
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

