Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbbA2HqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:46:15 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31849 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbbA2HqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:46:13 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-43-54c9e542b29c
Date: Thu, 29 Jan 2015 08:45:49 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Amit Kachhap <amit.daniel@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] dts: Documentation: Add documentation for Exynos7
 SoC thermal bindings
Message-id: <20150129084549.56300738@amdc2363>
In-reply-to: <20150128172319.GG29600@developer.hsd1.ca.comcast.net>
References: <1422337703-11289-1-git-send-email-a.kesavan@samsung.com>
 <CAM4voan-aoVQtRCFaB2rLLOgm+CEXg+Mc2gwfokUTu5eeQDo+g@mail.gmail.com>
 <20150128172319.GG29600@developer.hsd1.ca.comcast.net>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t9jQV2npydDDCYd17VouBpisXHGelaL
	+VeusVqs+atk0bvgKpvF5V1z2Cw+9x5htJhxfh+TxZOHfWwOnB47Z91l91i85yWTR9+WVYwe
	nzfJBbBEcdmkpOZklqUW6dslcGV8un2ctWCTSMW/VWvZGhgv8XcxcnBICJhIvH7k2sXICWSK
	SVy4t56ti5GLQ0hgOqPE0Q8vmSGcX4wSUz/cZwSpYhFQlVi3ZAsTiM0moCfx+e5TMFtEQEvi
	xKXtTCANzAK9zBIdH14zgySEBVIkbrxqBLN5gRqOze4Aa+AUcJaYvvMYO8SGo4wSm5qfs4Mk
	+AUkJdr//WCGuMlO4tynDewQzYISPybfYwGxmYG2bd7WxAphy0tsXvOWeQKj4CwkZbOQlM1C
	UraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAcPJPewbiqweIQowAHoxIPb0LjyRAh
	1sSy4srcQ4wSHMxKIrzXm4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZXs20KEBNITS1KzU1ML
	UotgskwcnFINjDJKvYs2MQS/3/ZF4d2pzB+SmzLmpE7asehK4OLfi+qyHimmh1h19m++kO/+
	9/4ak09X9GWvWoXsu/dsmbr+zxm3zszQnpr37dzhwuueUUXV7dNW3GSdpSGyOWSBwgGG41Pb
	m2L+z173+ahcQWl236Xr3rO/zWsRmBHXX7Okpt8wYJaRkY/l2SglluKMREMt5qLiRACrU5NP
	fwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> On Wed, Jan 28, 2015 at 04:21:49PM +0530, Abhilash Kesavan wrote:
> > Hi Eduardo,
> > 
> > On Tue, Jan 27, 2015 at 11:18 AM, Abhilash Kesavan
> > <a.kesavan@samsung.com> wrote:
> > > Add documentation for exynos7 thermal bindings including
> > > compatible name and special clock properties.
> > >
> > > Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> > > ---
> > >  .../devicetree/bindings/thermal/exynos-thermal.txt |    4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git
> > > a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> > > b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> > > index 0f44932..695150a 100644 ---
> > > a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> > > +++
> > > b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt @@
> > > -12,6 +12,7 @@ "samsung,exynos5420-tmu-ext-triminfo" for TMU
> > > channels 2, 3 and 4 Exynos5420 (Must pass triminfo base and
> > > triminfo clock) "samsung,exynos5440-tmu"
> > > +              "samsung,exynos7-tmu"
> > >  - interrupt-parent : The phandle for the interrupt controller
> > >  - reg : Address range of the thermal registers. For soc's which
> > > has multiple instances of TMU and some registers are shared
> > > across all TMU's like @@ -32,10 +33,13 @@
> > >  - clocks : The main clocks for TMU device
> > >         -- 1. operational clock for TMU channel
> > >         -- 2. optional clock to access the shared registers of
> > > TMU channel
> > > +       -- 3. optional special clock for functional operation
> > >  - clock-names : Thermal system clock name
> > >         -- "tmu_apbif" operational clock for current TMU channel
> > >         -- "tmu_triminfo_apbif" clock to access the shared
> > > triminfo register for current TMU channel
> > > +       -- "tmu_sclk" clock for functional operation of the
> > > current TMU
> > > +               channel
> > >  - vtmu-supply: This entry is optional and provides the regulator
> > > node supplying voltage to TMU. If needed this entry can be placed
> > > inside board/platform specific dts file.
> > 
> > Can you kindly consider applying these two patches to your next tree
> > if they look OK ?
> 
> Abhilash, can you please get at least one Reviewed-by from one of the
> active developers of exynos thermal driver?

I will review your patches. :-)

> 
> 
> > 
> > Regards,
> > Abhilash
> > > --
> > > 1.7.9.5
> > >



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
