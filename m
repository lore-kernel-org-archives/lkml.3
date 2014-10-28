Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbaJ1KTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 06:19:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55448 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbaJ1KTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 06:19:33 -0400
X-AuditID: cbfee691-f79b86d000004a5a-58-544f6dab3dc2
From: Kukjin Kim <kgene@kernel.org>
To: "'Jonathan Cameron'" <jic23@kernel.org>,
        "'Naveen Krishna Chatradhi'" <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org
References: <1410857931-4980-1-git-send-email-ch.naveen@samsung.com>
 <541EC1C2.6090608@kernel.org> <5436EA85.90900@kernel.org>
 <544C04E6.50401@kernel.org>
In-reply-to: <544C04E6.50401@kernel.org>
Subject: RE: [PATCH v2 0/3] iio: exynos-adc: use syscon instead of ioremap
Date: Tue, 28 Oct 2014 19:19:22 +0900
Message-id: <03d601cff298$a4bacc90$ee3065b0$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQNDhaw6+NRflUds/10k7u6YFRdlsgHkiU9bAjSO+dMBDk9DV5k06Xdw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zY93Vuf4hBmvP8li8PKRpcf3Lc1aL
	+UfOsVo0L17PZvHqyA8miwdNq5gslkyez2ox78g7FovLu+awWcw4v4/JYtG2/8wO3B6zGy6y
	eOycdZfdY9OqTjaP/XPXsHsseXOI1aNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgyjq5+wliw
	VLTizbyNLA2MiwS6GDk5JARMJD6+OMMCYYtJXLi3nq2LkYtDSGAZo8TP2StYYIoW3mqHSixi
	lLi2aTILhPOXUWLmp/esXYwcHGwCyhKNTfogDcICWhILtzSB1YgI7GaUePTwClg3s8BaRom2
	bVfZIbrnMUrs/nyEEaSFU0BD4tja28wQ7V4SG3fcANvNIqAq8f7JCiYQm1fAQuL0pPMsELag
	xI/J98BsZqB163ceZ4Kw5SU2r3nLDHG3gsSOs68ZQa4TEXCTeLjbBaJERGLfi3eMIDdICCzl
	kNj2fx7ULgGJb5MPsYDUSwjISmw6ADVGUuLgihssExglZyHZPAvJ5llINs9CsmIBI8sqRtHU
	guSC4qT0IlO94sTc4tK8dL3k/NxNjJCkMHEH4/0D1ocYBTgYlXh4DR76hQixJpYVV+YeYjQF
	umgis5Rocj4w9eSVxBsamxlZmJqYGhuZW5opifPqSP8MFhJITyxJzU5NLUgtii8qzUktPsTI
	xMEp1cCYJ9GvVlavs4Wz3r9o+dPNzpnJWpWxhT9Vrk87IL85L6FjZdcPe6FlKl86kruunq5j
	/Mnt16PyYk2tYptymddjbc7LGac4V8eeq7lmfivtNvP7aZ7tuvsLjJpKrh1W/HovxPfgfaGK
	PXd28qXa84oc29l7p/Le1ash32fNuXvXoS/pWqWDwlIlluKMREMt5qLiRADmO8LxBQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jAd3Vuf4hBh9fsVu8PKRpcf3Lc1aL
	+UfOsVo0L17PZvHqyA8miwdNq5gslkyez2ox78g7FovLu+awWcw4v4/JYtG2/8wO3B6zGy6y
	eOycdZfdY9OqTjaP/XPXsHsseXOI1aNvyypGj8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2V
	vIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAjlRSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYxZhxd/YSxYKloxZt5G1kaGBcJdDFyckgImEgsvNXOBmGLSVy4tx7I
	5uIQEljEKHFt02QWCOcvo8TMT+9Zuxg5ONgElCUam/RBGoQFtCQWbmkCqxER2M0o8ejhFbBu
	ZoG1jBJt266yQ3TPY5TY/fkII0gLp4CGxLG1t5kh2r0kNu64wQJiswioSrx/soIJxOYVsJA4
	Pek8C4QtKPFj8j0wmxlo3fqdx5kgbHmJzWveMkPcrSCx4+xrRpDrRATcJB7udoEoEZHY9+Id
	4wRG4VlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGccp5J7WBc
	2WBxiFGAg1GJh9fgoV+IEGtiWXFl7iFGCQ5mJRHeiBj/ECHelMTKqtSi/Pii0pzU4kOMpkCP
	TmSWEk3OB6bDvJJ4Q2MTMyNLIzMLIxNzcyVx3gOt1oFCAumJJanZqakFqUUwfUwcnFINjEUR
	EsKqR2VlT7xftCKmSurd0+ePtJPmLtC+VT9R65fevtd3/v9wvXBludeETbELpx6wVVNxW9St
	f7i9yXpN5e8Vum7Cmv6+68QU1W50mRxnjdA7eZt5weUEkdu2Fgq+j78J3/9yvfI6o8Zn5znP
	f91P2nhGq1Booecrw8oTCw4aWbXXyGbdVVViKc5INNRiLipOBABcULPmTwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Cameron wrote:
> 
> On 09/10/14 21:05, Jonathan Cameron wrote:
> > On 21/09/14 13:17, Jonathan Cameron wrote:
> >> On 16/09/14 09:58, Naveen Krishna Chatradhi wrote:
> >>> Changes since v1:
> >>> 1. Rebased on top of togreg branch of IIO git.
> >>>
> >>> This patch set does the following
> >>> 1. Use the syscon and Regmap API instead of ioremappaing the
> >>>    ADC_PHY register from PMU.
> >>> 2. Updates the Documentation in exynos-adc.txt with syscon phandle
> >>>    for the ADC nodes.
> >>> 3. Updates the Dts files for Exynos3250, Exynos4x12, Exynos5250,
> >>>    Exynos5420 with the syscon phandle.
> >>>
> >>> Tested on Exynos5420 based Peach PIT and Exynos5800 based Peach PI
> >>> by verifying sysfs entries provided by HWMON based NTC thermistors.
> >>>
> >>> Tested-By for Exynos3250, Exynos4x12 would be appreciated.
> >> Would definitely be good!
> >>
> >> The main issue I have with this series is that it breaks backward
> >> compatibility with old device trees and newer kernels.
> >>
> >> Now I appreciate that sometimes there are reasons to do it but want this
> >> to have deeper consideration (and acks to show it) from the Exynos side
> >> of things and preferably from the device tree side of things as well.
> >>
> >> cc'd Kukjin Kim for the Exynos side of things as the listed Maintainer.
> >>
> >> Otherwise, the series looks fine to me.
> > Kukjin? Sorry to pester, but this has been sat in my waiting queue for a
> > while now.
> This is still sitting here waiting for those acks from Exynos side of things.
> I'm happy to let this sit indefinitely, but does seem a little silly.
> >>>

Thanks for asking :)

Since I've missed the patch in my mailbox and just now checked. I'm happy with
Naveen's dt updates, I'm not sure we can see useless merge conflicts though ;)
Anyway it should be small, so please feel free to add my ack on the change.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

- Kukjin

> >>> Naveen Krishna Chatradhi (3):
> >>>   iio: exyno-adc: use syscon for PMU register access
> >>>   Documentation: dt-bindings: update exynos-adc.txt with syscon handle
> >>>   ARM: dts: exynos: Add sysreg phandle to ADC node
> >>>
> >>>  .../devicetree/bindings/arm/samsung/exynos-adc.txt |    9 ++++--
> >>>  arch/arm/boot/dts/exynos3250.dtsi                  |    3 +-
> >>>  arch/arm/boot/dts/exynos4x12.dtsi                  |    3 +-
> >>>  arch/arm/boot/dts/exynos5250.dtsi                  |    3 +-
> >>>  arch/arm/boot/dts/exynos5420.dtsi                  |    3 +-
> >>>  drivers/iio/adc/exynos_adc.c                       |   30 ++++++++++++++------
> >>>  6 files changed, 36 insertions(+), 15 deletions(-)

