Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217Ab3JNFw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 01:52:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:51770 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab3JNFwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 01:52:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,490,1378882800"; 
   d="scan'208";a="307382443"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Lukasz Majewski <l.majewski@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Amit Daniel Kachhap" <amit.daniel@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: RE: [PATCH v2 0/5] thermal: exynos: Fixes for v3.12
Thread-Topic: [PATCH v2 0/5] thermal: exynos: Fixes for v3.12
Thread-Index: AQHOxLkjmaAGqPyX2EmS+yNHrsdoLpnzMe2AgACGu8A=
Date: Mon, 14 Oct 2013 05:52:19 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926301190077@SHSMSX101.ccr.corp.intel.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
 <20131014074635.77fd9f6e@amdc308.digital.local>
In-Reply-To: <20131014074635.77fd9f6e@amdc308.digital.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo,

What's your opinion on this patch set?
BTW, please send me all the urgent fixes for thermal soc drivers that you think should go to 3.12.

Thanks,
rui
> -----Original Message-----
> From: Lukasz Majewski [mailto:l.majewski@samsung.com]
> Sent: Monday, October 14, 2013 1:47 PM
> To: Zhang, Rui; Eduardo Valentin; kgene.kim@samsung.com
> Cc: Lukasz Majewski; Linux PM list; Lukasz Majewski; linux-kernel;
> Bartlomiej Zolnierkiewicz; devicetree@vger.kernel.org; Amit Daniel
> Kachhap; linux-samsung-soc@vger.kernel.org
> Subject: Re: [PATCH v2 0/5] thermal: exynos: Fixes for v3.12
> Importance: High
> 
> Hi Zhang, Eduardo,
> 
> > This patch series is divided into two parts:
> > 1. Device tree node definition and enabelement for TMU at Exynos4412
> > (Trats2) 2. Exynos thermal subsystem regressions for v3.12-rc4.
> > Several commits were necessary to properly fix regression for TMU
> test
> > MUX address setting after reset.
> >
> > Test HW:
> > - Exynos4412 - TRATS2 board (Linux v3.12-rc4)
> > SHA1: 8b5ede69d24db939f52b47effff2f6fe1e83e08b
> >
> >
> > Lukasz Majewski (5):
> >   thermal: exynos: Remove check for thermal device pointer at
> >     exynos_report_trigger()
> >   thermal: exynos: Provide separate TMU data for Exynos4412
> >   thermal: exynos: Provide initial setting for TMU's test MUX address
> >     at Exynos4412
> >   ARM: dts: exynos4x12: Device tree node definition for TMU on
> >     Exynos4x12
> >   ARM: dts: exynos4412-trats2: Enable TMU support at Trats2
> >
> 
> Zhang, Eduardo - any comments?
> 
> Would it be possible to add them to v3.12 since they do fix critical
> error and regression on Exynos4412.
> 
> 
> >  arch/arm/boot/dts/exynos4412-trats2.dts         |    5 ++++
> >  arch/arm/boot/dts/exynos4x12.dtsi               |   10 ++++++++
> >  drivers/thermal/samsung/exynos_thermal_common.c |    2 --
> >  drivers/thermal/samsung/exynos_tmu.c            |   12 ++++++---
> >  drivers/thermal/samsung/exynos_tmu.h            |    7 +++++-
> >  drivers/thermal/samsung/exynos_tmu_data.c       |   30
> > ++++++++++++++++++-----
> > drivers/thermal/samsung/exynos_tmu_data.h       |   13 +++++++++- 7
> > files changed, 65 insertions(+), 14 deletions(-)
> >
> 
> 
> 
> --
> Best regards,
> 
> Lukasz Majewski
> 
> Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
