Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbbAWGv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:51:59 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:46606 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbbAWGv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:51:56 -0500
X-AuditID: cbfee691-f79b86d000004a5a-81-54c1ef8a6824
From: Kukjin Kim <kgene@kernel.org>
To: "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Mike Turquette'" <mturquette@linaro.org>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Kukjin Kim'" <kgene@kernel.org>
Cc: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Arun Kumar K'" <arun.kk@samsung.com>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Tobias Jakobi'" <liquid.acid@gmx.net>,
        "'Andrzej Hajda'" <a.hajda@samsung.com>,
        "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>,
        "'Kevin Hilman'" <khilman@linaro.org>,
        "'Joonyoung Shim'" <jy0922.shim@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1421750127-22536-1-git-send-email-javier.martinez@collabora.co.uk>
 <1421750127-22536-2-git-send-email-javier.martinez@collabora.co.uk>
 <54BE6050.1090205@samsung.com> <20150120175402.22722.84342@quantum>
 <54BF81C2.3020000@collabora.co.uk>
In-reply-to: <54BF81C2.3020000@collabora.co.uk>
Subject: RE: [PATCH 1/2] clk: exynos5420: Add IDs for clocks used in DISP1
 power domain
Date: Fri, 23 Jan 2015 15:51:53 +0900
Message-id: <0c2601d036d9$1276e7d0$3764b770$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQKLM7a9dpudVcmkoOQlCmzan0VHmQDyELWGAk2+MTEBu6tPogKWJGFemxq7p2A=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t8zY92u9wdDDDaelba4te4cq8XHU7dZ
	Lc4uO8hmcfR3gcWLexdZLF6/MLTof/ya2eLr4RWMFpseX2O1uLxrDpvFjPP7mCy6fv5ks1h7
	5C67xdMJF9ksTl3/zGYxZdFhVovDb9pZLVbt+sPoIOQxu+Eii8ff59dZPHbOusvusXjTfjaP
	Tas62TzuXNvD5rF5Sb3HlRNNrB59W1YxenzeJBfAFcVlk5Kak1mWWqRvl8CVsWn1csaCFfwV
	TS9uMDcwtvN0MXJwSAiYSBy5YdjFyAlkiklcuLeerYuRi0NIYBmjRMeqdYwQCROJr1NboRKL
	GCX+zN3GDJIQEvjLKNF8hB1kEJuAskRjkz5IWFhAS2LhliYWkHoRgX2MEkufNIE1MwvsY5GY
	93sLC0RzA5PEmQ55EJtTQF/i6uc97BDdkRLPlz5nArFZBFQlDnxazAZi8wpYSMw+/5cdwhaU
	+DH5HtgcZgF1iUnzFjFD2PISm9e8ZYa4WkFix9nXjBBxEYl9L96B2SICfhKfP/VDffaCQ2LH
	fzOIXQIS3yYfYoGEiqzEpgNQYyQlDq64wTKBUXIWks2zkGyehWTzLCTbFjCyrGIUTS1ILihO
	Si8y1StOzC0uzUvXS87P3cQISTcTdzDeP2B9iFGAg1GJh7dhy8EQIdbEsuLK3EOMpkAXTWSW
	Ek3OBya1vJJ4Q2MzIwtTE1NjI3NLMyVxXh3pn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUa
	GM/mNom72DW/jb5gMylC8Oa/tWFtMiHKy4SuvRG//W3WqahFi699YXt10kF/5naT+Wx3ji8S
	PFGe78STsPf8eh2hVd+URA2rv/zeIfvqWz/TX59DqdeTbyefvLP03qufPLLmovqmxWfObEg1
	kjz7LaDNSvZJQN3tfRt9Y70miAS+eGZz4NrbA55KLMUZiYZazEXFiQDDBbCKMgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA2WSaUwTQRiGM92jC7FxLa1O+KF1hRhICrRyDKhoIpqNV4jWCP7BFdaC9koX
	8PhjrVG0JoK3qUqUQxERYkGDiOUoGm8kKgIqJqKAghpBAiqHPYIhOr+evDPPm+9LhsKkfUQg
	lWHI5M0GTseQ/vij8S5aafvWoIkovC5HHeVPCfT94WsCPbnUQKK7v02ot7MFR329KpTb1Yeh
	IVcJQI6uVgI9rzlHojPNThGy/fxJomtNb8XoY14LiR6+GiTRiQIXgVz9OQQqrRkFS6XsWUsL
	zo71vMLZW/a3YrbQUUeyjtJDJPumtZZkK4v2sC/uWwn2SFUpYAcdsxP9N1nAonSeS+PNCt6Q
	akzLMGgXM6vWpyxLiYqOUClVsSiGURg4Pb+YSVidqFyRoXMvxSiyOV2WO0rkBIEJj/+/YYNm
	hRJNiknKNZp1fx11xD9nczlId1y9DEwl03dae9swC8iZZgN+FKQj4dDJ/aSPZ8JnnRVu9qek
	dAGAo+dvYp4LKT0G4L4msQ1QFEnPg3ut4Z44gA6FF6usuOe9jHYCWPzB6pUx2onD/N9VuE+2
	iODjg3M87EeHw5eDtWKfnQx7intEHsbpYFg/UOidQkIjeLZ5TOzjGXDkeKe3B6Pnw2P5BZiP
	58DKsi+Yb2oFrH7SB3y5DDp7v3pZRq+FgwO5IA8E2KdU2adU2adU2afoFwBeCuS8KdUkbNHq
	VWECpxeyDNqwVKPeAbwfrTuwGlyxoEZAU4CZJrFUNWikBJct7NI3AkhhjExy+L07kqRxu3bz
	ZmOKOUvHC40gyr3pUSxQnmp0f1tDZopqQWS0OlYdjdSRMTHMLAmz5IBGSmu5TH47z5t486Qn
	ovwCLaAifgCujLfNtBxwxNe/Hw7eNt5mHO6av6w/NhmGjL8rhN+MpwA+oepvlefs1YZMLNQV
	RcR9nYhrMLpGfh0eGQnYKiwf5YKibzvk3ZSm/dMOdcXp4Qcbs44EHXQGL4rZWpY0Fy+58Suq
	sb3jHv1D/SHhM7poGi/iVrNBdeHE0B0GF9I5VShmFrg/vNyZRn4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier Martinez Canillas wrote:
> 
> Hello,
> 
Hi,

> On 01/20/2015 06:54 PM, Mike Turquette wrote:
> > Quoting Sylwester Nawrocki (2015-01-20 06:04:00)
> >> Hi,
> >>
> >> On 20/01/15 11:35, Javier Martinez Canillas wrote:
> >> > When a power domain is powered off on Exynos5420 SoC, the input clocks of
> >> > the devices attached to this power domain are re-parented to oscclk and
> >> > restored to the original parent after powering on the power domain.
> >> >
> >> > So a reference to the input and parent clocks for the devices attached to
> >> > a power domain are needed to be able to do the re-parenting. The DISP1 pd
> >> > includes modules which uses the following clocks:
> >> >
> >> > ACLK_200_DISP1 (MIXER and HDMILINK)
> >> > ACLK_300_DISP1 (FIMD1)
> >> > ACLK_400_DISP1 (Internal Buses)
> >> >
> >> > Each of these clocks are generated as the output of a clock mux so add an
> >> > ID for all of these clock muxes and their parents to be referenced in the
> >> > DISP1 power domain device node.
> >> >
> >> > Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> >>
> >> The patch looks OK to me, I'm fine with it being merged via Kukjin's tree
> >> due to the dts dependencies (including other pending dts patches touching
> >> the arch/arm/boot/dts/exynos5420.dtsi file).
> >> I think we need also Mike ACK for that, I could also queue the patch for
> >> the clk tree and create a topic branch, but merging both patches via
> >> arm-soc seems a more sane option in this case.
> >>
> >> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >
> > Acked-by: Michael Turquette <mturquette@linaro.org>
> >
> 
> Thanks a lot Sylwester and Mike for your acks.
> 
> Kukjin, could you please pick $subject and "Patch 2/2 ARM: dts: Add DISP1
> power domain for exynos5420" through your tree?
> 
Sure, I will after applying Marek's generic power domain patch.

Thanks,
Kukjin

