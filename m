Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab3JOGXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:23:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37060 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab3JOGXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:23:10 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-21-525cdf4d52cf
Date: Tue, 15 Oct 2013 08:23:03 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] thermal: exynos: Fixes for v3.12
Message-id: <20131015082303.3ec02e2a@amdc308.digital.local>
In-reply-to: <525C4487.2030502@ti.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
 <20131014074635.77fd9f6e@amdc308.digital.local>
 <744357E9AAD1214791ACBA4B0B90926301190077@SHSMSX101.ccr.corp.intel.com>
 <525C4242.2050306@ti.com> <525C4487.2030502@ti.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t9jQV3f+zFBBksuKlo0XA2x2DhjPavF
	/CPnWC3W7P/JZNG74CqbxZtH3BaXd81hs/jce4TRYsb5fUwWTx72sTlweSze85LJY920t8we
	fVtWMXocv7GdyePzJrkA1igum5TUnMyy1CJ9uwSujGOLdrEVfJauaJ5X0sB4XbSLkZNDQsBE
	4kVjCyOELSZx4d56ti5GLg4hgemMEu//LmaGcNqZJBbePwhWxSKgKjGpYyUbiM0moCfx+e5T
	JhBbBMi+8eIJE0gDs8B5Zoll7T2sIAlhARuJa+uugDXzClhLvJ+xkRnE5hRQk1h7bysLxIat
	TBJ9bQdYQBL8ApIS7f9+MEPcZCdx7tMGdohmQYkfk++B1TALaEls3tbECmHLS2xe85Z5AqPg
	LCRls5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcGw8k97BuKrB4hCjAAej
	Eg/vD96YICHWxLLiytxDjBIczEoivDnVQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE
	0hNLUrNTUwtSi2CyTBycUg2MwsIzF6ptYK9i/rGswfvxo5jNZz0ThFvOnVjAxtGVWZ+dJFOd
	Y7KySdVS+/7Nh+ltbXofFzLN1EgI/nNaJPn4MvUgy6BkF4cHu5gcDtU5HbuRdoB/6j63gnXf
	N1yZtbvmRPDlFxUcj/6eONbhMyP/h3bSRGGjqf2ClUEFbRtbZ6TNif6yLfuYEktxRqKhFnNR
	cSIAWmi4T4kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> On 14-10-2013 15:13, Eduardo Valentin wrote:
> > On 14-10-2013 01:52, Zhang, Rui wrote:
> >> Eduardo,
> >>
> >> What's your opinion on this patch set?
> >> BTW, please send me all the urgent fixes for thermal soc drivers
> >> that
> > you think should go to 3.12.
> >>
> > 
> > I will be sending these + one fix on ti soc thermal for 3.12 soon.
> > 
> > The new chip support on exynos needs to be reworked and there are
> > couple of new drivers that needs to be reworked too. But those I
> > don't think are ready to go now.
> > 
> 
> Just to be clear, on this patch set obviously I wont be sending the DT
> changes. Those should go via the correct tree.

I understand. I will ask Mr. Kukjin Kim to take the DT changes.

> 
> >> Thanks,
> >> rui
> >>> -----Original Message-----
> >>> From: Lukasz Majewski [mailto:l.majewski@samsung.com]
> >>> Sent: Monday, October 14, 2013 1:47 PM
> >>> To: Zhang, Rui; Eduardo Valentin; kgene.kim@samsung.com
> >>> Cc: Lukasz Majewski; Linux PM list; Lukasz Majewski; linux-kernel;
> >>> Bartlomiej Zolnierkiewicz; devicetree@vger.kernel.org; Amit Daniel
> >>> Kachhap; linux-samsung-soc@vger.kernel.org
> >>> Subject: Re: [PATCH v2 0/5] thermal: exynos: Fixes for v3.12
> >>> Importance: High
> >>>
> >>> Hi Zhang, Eduardo,
> >>>
> >>>> This patch series is divided into two parts:
> >>>> 1. Device tree node definition and enabelement for TMU at
> >>>> Exynos4412 (Trats2) 2. Exynos thermal subsystem regressions for
> >>>> v3.12-rc4. Several commits were necessary to properly fix
> >>>> regression for TMU
> >>> test
> >>>> MUX address setting after reset.
> >>>>
> >>>> Test HW:
> >>>> - Exynos4412 - TRATS2 board (Linux v3.12-rc4)
> >>>> SHA1: 8b5ede69d24db939f52b47effff2f6fe1e83e08b
> >>>>
> >>>>
> >>>> Lukasz Majewski (5):
> >>>>   thermal: exynos: Remove check for thermal device pointer at
> >>>>     exynos_report_trigger()
> >>>>   thermal: exynos: Provide separate TMU data for Exynos4412
> >>>>   thermal: exynos: Provide initial setting for TMU's test MUX
> >>>> address at Exynos4412
> >>>>   ARM: dts: exynos4x12: Device tree node definition for TMU on
> >>>>     Exynos4x12
> >>>>   ARM: dts: exynos4412-trats2: Enable TMU support at Trats2
> >>>>
> >>>
> >>> Zhang, Eduardo - any comments?
> >>>
> >>> Would it be possible to add them to v3.12 since they do fix
> >>> critical error and regression on Exynos4412.
> >>>
> >>>
> >>>>  arch/arm/boot/dts/exynos4412-trats2.dts         |    5 ++++
> >>>>  arch/arm/boot/dts/exynos4x12.dtsi               |   10 ++++++++
> >>>>  drivers/thermal/samsung/exynos_thermal_common.c |    2 --
> >>>>  drivers/thermal/samsung/exynos_tmu.c            |   12 ++++++---
> >>>>  drivers/thermal/samsung/exynos_tmu.h            |    7 +++++-
> >>>>  drivers/thermal/samsung/exynos_tmu_data.c       |   30
> >>>> ++++++++++++++++++-----
> >>>> drivers/thermal/samsung/exynos_tmu_data.h       |   13
> >>>> +++++++++- 7 files changed, 65 insertions(+), 14 deletions(-)
> >>>>
> >>>
> >>>
> >>>
> >>> --
> >>> Best regards,
> >>>
> >>> Lukasz Majewski
> >>>
> >>> Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> >> linux-pm" in the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >>
> > 
> > 
> 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
