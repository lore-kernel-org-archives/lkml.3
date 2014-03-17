Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbaCQA2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 20:28:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17753 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbaCQA2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 20:28:35 -0400
X-AuditID: cbfee68e-b7f566d000002344-4f-532641b0da1a
Date: Mon, 17 Mar 2014 09:28:32 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 11/27] clk: exynos: add gate clock descriptions of
 System MMU
Message-id: <20140317092832.af0e8e8b503c98eb639dd09a@samsung.com>
In-reply-to: <5322F356.6030608@samsung.com>
References: <20140314140621.14df1e40601c4f6a2487b5a8@samsung.com>
 <5322F356.6030608@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t8zI90NjmrBBufn6lvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJVxf8VCtoJHfBXXJ51kbGA8xN3FyMkhIWAi8efmRHYI
	W0ziwr31bF2MXBxCAssYJdp6D7LCFDVNvscKkVjEKPHoxVawDiGByUwShzYpgNgsAqoSS1/+
	A4uzCWhJrJ57nBHEFhFQkbh8ajojSDOzQCOrxKP7y4CK2DmEBcIlrjKDlPAKOEo8XfwAbBen
	gLbE3L7ZLBDjkyTenLgGdZyFxIWmDnaIekGJH5PvgdUwA63avK2JFcKWl9i85i0zyCoJgYUc
	En0XJzFD3CYg8W3yIaAGDqCErMSmA8wQMyUlDq64wTKBUWwWkrGzkIydhWTsAkbmVYyiqQXJ
	BcVJ6UVGesWJucWleel6yfm5mxghkd63g/HmAetDjMlAKycyS4km5wMTRV5JvKGxmZGFqYmp
	sZG5pRlpwkrivIseJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYCzt9XzP+W7insXfXbjM
	46byzeR8FRhVsHivzv45OV7MutPrr/Q8b7z4/9OHC4YHz3fOe/3k4hOXFyGfHx9c+Tc10UB2
	Ufxz9e3yr0MNduTOtS2u2Cjzcud0Vc9Vl31d4j/N3ZRkHCIor2r1zFey+P4OZ5NDCsIBiZMs
	3QJXHeRlXWa5eEn0XSklluKMREMt5qLiRADvDYn5CgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsVy+t9jAd0NjmrBBo+3aFrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/6KhWwFj/gq
	rk86ydjAeIi7i5GTQ0LARKJp8j1WCFtM4sK99WxdjFwcQgKLGCUevdjKDpIQEpjMJHFokwKI
	zSKgKrH05T+wOJuAlsTquccZQWwRARWJy6emM4I0Mws0sko8ur8MqIidQ1ggXOIqM0gJr4Cj
	xNPFD8B2cQpoS8ztm80CMT5J4s2Ja+wQN1hIXGjqYIeoF5T4MfkeWA0z0KrN25pYIWx5ic1r
	3jJPYBSYhaRsFpKyWUjKFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQITiPPpHcwrmqw
	OMQowMGoxMM7QVktWIg1say4MvcQowQHs5IIb4I5UIg3JbGyKrUoP76oNCe1+BBjMjAwJjJL
	iSbnA1NcXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUw5mSy
	l+s6l0Se+MOQJZI6T/2s/JpG/oO8uvtsNFbuV3KNSk9v3De5pjxJckVQ62O2O3lV6izWN34s
	WSGydQZbmPlN3k0L8iUcrac8mLJM7P7RwOmHna7vjm67q5S9dFVg+ha2La7VOVxfXcxmb7vd
	0n3tvQdX8KlFX95zHT500XdyeTb7k59LlViKMxINtZiLihMB63nALGcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 13:17:26 +0100, Tomasz Figa wrote:
> Hi KyongHo,
> 
> On 14.03.2014 06:06, Cho KyongHo wrote:
> > This adds gate clocks of all System MMUs and their master IPs
> > that are not apeared in clk-exynos5250.c and clk-exynos5420.c
> > Also fixes GATE_IP_ACP to 0x18800 and changed GATE_DA to GATE
> > for System MMU clocks in clk-exynos4.c
> >
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >   .../devicetree/bindings/clock/exynos5250-clock.txt |    3 +++
> >   .../devicetree/bindings/clock/exynos5420-clock.txt |    6 +++++-
> >   drivers/clk/samsung/clk-exynos5250.c               |    5 +++++
> >   drivers/clk/samsung/clk-exynos5420.c               |   13 +++++++++++--
> >   include/dt-bindings/clock/exynos5250.h             |    4 ++++
> >   include/dt-bindings/clock/exynos5420.h             |    6 +++++-
> >   6 files changed, 33 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> > index 72ce617..67e50ba 100644
> > --- a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> > +++ b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> > @@ -162,6 +162,9 @@ clock which they consume.
> >     g2d			345
> >     mdma0			346
> >     smmu_mdma0		347
> > +  smmu_tv		348
> > +  smmu_fimd1		349
> > +  smmu_2d		350
> >
> 
> This patch should be rebased on top of Andrzej Hajda's patches removing 
> these clock ID listings and reworking dts files to use defined macros. 
> They are present in v3.15-next/dt-clk-exynos branch of linux-samsung 
> tree, but I have asked Kukjin to merge them to his for-next branch, so 
> they could show up in linux-next tree.
> 

Thanks for the information.
I will also ask Kukjin for the correct base of the patches.

KyongHo.
