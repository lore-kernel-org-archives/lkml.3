Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaHTOQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:16:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63428 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaHTOQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:16:21 -0400
X-AuditID: cbfee61a-f79e46d00000134f-eb-53f4adb34e20
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: "edubezval@gmail.com" <edubezval@gmail.com>
Cc: amit daniel kachhap <amit.daniel@samsung.com>,
        Zhang Rui <rui.zhang@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/9] thermal: exynos: various cleanups
Date: Wed, 20 Aug 2014 16:16:15 +0200
Message-id: <1748435.DsACgyNnAN@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <CAC-25o9xxKtsphuY51Fhv3CBFKxMoJ1SGMJypLkt9fvHnTsQxA@mail.gmail.com>
References: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
 <5064578.QsHz5kKYq8@amdc1032>
 <CAC-25o9xxKtsphuY51Fhv3CBFKxMoJ1SGMJypLkt9fvHnTsQxA@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=UTF-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQd3Na78EG9y9LWrRcDXEYv6Va6wW
	Z5vesFtc3jWHzeJz7xFGixnn9zFZnDl9idXiycM+Nov1M16zOHB67Jx1l91j8Z6XTB5brraz
	ePRtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfG6TtbmQvm61VMvzWFpYGxWaWLkZNDQsBE4s2h
	Z6wQtpjEhXvr2UBsIYHpjBLH7qt2MXIB2S1MEp+mzGAHSbAJWElMbF/FCGKLCOhLPGp6wQhS
	xCwwmVni6P5+sISwgK3E0R2HwBpYBFQlnnZ2gm3gFdCUuDrrOQuILSrgKbFj+0qgbRwcnALB
	EvNO+UMsW88osf7LFEaIekGJH5PvgdUzC8hL7Ns/lRXCVpeYNG8R8wRGgVlIymYhKZuFpGwB
	I/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODAfya1g3Flg8UhRgEORiUe3oYFX4KFWBPL
	iitzDzFKcDArifC2dwKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnNTk0tSC2C
	yTJxcEo1MOocOL7Z2mHpTLN7rntvB6z5fPCU3P0ND77qBRpdnp/KEuCUfKxSTu3p0dB93t9T
	13KvWnp+9232zHkFqZN2KJ+PccoJf7OQOdfobvH/b22tq/3PLAvKzTxnuuFAupdZxIdU7gW/
	G/nOqQq9v/XlkczK2VLlW2N7a9bwTG670D37mv49bjWhGaeVWIozEg21mIuKEwHym/aYeAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday, August 01, 2014 09:18:30 AM edubezval@gmail.com wrote:
> Bartlomiej,
> 
> On Thu, Jul 31, 2014 at 1:37 PM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> >
> > Hi,
> >
> > On Tuesday, July 29, 2014 08:58:48 AM Eduardo Valentin wrote:
> >> On Mon, Jul 28, 2014 at 08:30:53PM +0530, amit daniel kachhap wrote:
> >> > Hi Eduardo,
> >>
> >> Hello Amit,
> >>
> >> >
> >> > Please reject this entire series as this is not re-based recently.
> >> > Actually two point trimming which this series seeks to remove is used
> >> > by exynos3250 and is in Rui's tree
> >> > (https://git.kernel.org/cgit/linux/kernel/git/rzhang/linux.git/commit/?h=next&id=1fe56dc16a3dab400206443f70ae158c8f595c42).
> >> >
> >>
> >> Yeah, that was my original concern when I first looked this series.
> >> However, as I saw a couple of your acks I thought you would be in sync
> >> with Bartlomiej.
> >>
> >> I agree with Bartlomiej that we need to keep the kernel code in very
> >> good shape, but if we are removing features for the sake of reducing
> >> LOCs and we end up dropping support to known chips, I definitely won't
> >> agree.
> >
> > There is no intention to drop support for known chips.  Two months after
> > initial posting of my patchset support for the new Exynos3250 SoC was
> > posted and it happens to use the two point trimming calibration code (that
> > was introduced back in September 2011 but never used previously).  If we
> > had removed it earlier it would have to be readded partially but we are
> > talking about less than 100 lines of rather straightforward code (also
> > the calibration code in question is not perfect anyway and would profit
> > from some cleaning but I left it as it is for now).
> >
> >> Can you guys please reach a common agreement on these cleanups?
> >>
> >> Bartlomiej, best thing to do is to sync your work on top of Rui's tree.
> >
> > Done, I posted v3 of patchset today:
> >
> >   http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35013.html
> >
> > I hope that it is acceptable for Amit now (Amit, please take a look at
> > patches when you find some time, thanks!).
> >
> 
> Thanks for updating the series.
> 
> Amit, can you please test the series on socs you have available? I
> would prefer to merge this one now if we have a proper tested-by.

Amit, could you please respond and give your opinion on this patch
series?  It has been almost three weeks since I've posted updated
version (over 3.5 months since the initial posting).

Eduardo, when it comes to testing this patch series I tested it on
Exynos4412 only but please note that it should not cause any
functionality changes (as stated in the cover letter) on any SoC.
This means that unless there are some bugs in the patches itself
there should be no behavior changes for the driver (including no
changes in the way hardware is accessed by the driver).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> > Best regards,
> > --
> > Bartlomiej Zolnierkiewicz
> > Samsung R&D Institute Poland
> > Samsung Electronics
> >
> >> For now I am dropping this series from my -next branch. :-(
> >>
> >> > Thanks,
> >> > Amit D
> >> >
> >> >
> >> > On Mon, Jul 28, 2014 at 8:07 PM, Eduardo Valentin <edubezval@gmail.com> wrote:
> >> > > On Tue, Jun 17, 2014 at 07:27:16PM +0200, Bartlomiej Zolnierkiewicz wrote:
> >> > >> Hi,
> >> > >>
> >> > >> This patch series contains various cleanups for EXYNOS thermal
> >> > >> driver.  Overall it decreases driver's LOC by 12%.  It is based
> >> > >> on next-20140617 kernel.  It should not cause any functionality
> >> > >> changes.
> >> > >>
> >> > >> Changes since v1:
> >> > >> - synced patches against next-20140617
> >> > >> - merged patch "thermal: exynos: remove unused defines" into
> >> > >>   "thermal: exynos: remove unused struct exynos_tmu_registers
> >> > >>   entries" one (per request from Eduardo)
> >> > >> - improved patch descriptions for patches #1-5
> >> > >> - fixed documentation for pdata->gain and pdata->reference_voltage
> >> > >> - added Reviewed-by from Amit to patches #6, #7 and #10
> >> > >> - added missing Acked-by from Kyungmin Park
> >> > >
> >> > > Pulled the series.
> >> > >
> >> > > Thanks.
> >> > >
> >> > >>
> >> > >> Best regards,
> >> > >> --
> >> > >> Bartlomiej Zolnierkiewicz
> >> > >> Samsung R&D Institute Poland
> >> > >> Samsung Electronics
> >> > >>
> >> > >>
> >> > >> Bartlomiej Zolnierkiewicz (9):
> >> > >>   thermal: exynos: remove unused struct exynos_tmu_registers entries
> >> > >>   thermal: exynos: remove dead code for HW_MODE calibration
> >> > >>   thermal: exynos: remove dead code for TYPE_TWO_POINT_TRIMMING
> >> > >>     calibration
> >> > >>   thermal: exynos: remove redundant pdata checks from
> >> > >>     exynos_tmu_initialize()
> >> > >>   thermal: exynos: remove redundant threshold_code checks from
> >> > >>     exynos_tmu_initialize()
> >> > >>   thermal: exynos: simplify temp_to_code() and code_to_temp()
> >> > >>   thermal: exynos: cache non_hw_trigger_levels in pdata
> >> > >>   thermal: exynos: remove redundant pdata checks from
> >> > >>     exynos_tmu_control()
> >> > >>   thermal: exynos: remove identical values from exynos*_tmu_registers
> >> > >>     structures
> >> > >>
> >> > >>  drivers/thermal/samsung/exynos_thermal_common.h |   1 -
> >> > >>  drivers/thermal/samsung/exynos_tmu.c            | 181 ++++--------------------
> >> > >>  drivers/thermal/samsung/exynos_tmu.h            |  90 +-----------
> >> > >>  drivers/thermal/samsung/exynos_tmu_data.c       |  64 +--------
> >> > >>  drivers/thermal/samsung/exynos_tmu_data.h       |  33 +----
> >> > >>  5 files changed, 41 insertions(+), 328 deletions(-)
> >> > >>
> >> > >> --
> >> > >> 1.8.2.3

