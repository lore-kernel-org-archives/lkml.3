Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaHEMEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:04:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49507 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaHEMEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:04:49 -0400
X-AuditID: cbfee61b-f79f86d00000144c-12-53e0c85fe9e1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v3 0/4] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with
 secure firmware enabled
Date: Tue, 05 Aug 2014 14:04:44 +0200
Message-id: <1616004.BFfRa8qesz@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <53D5FF06.6080904@linaro.org>
References: <1404926274-18411-1-git-send-email-b.zolnierkie@samsung.com>
 <53D5FF06.6080904@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=UTF-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jAd34Ew+CDR6fkLWY91nWonfBVTaL
	s01v2C3eH3rGbLHp8TVWi8u75rBZfO49wmgx4/w+Joszpy+xWpz808tosX7GaxaLjV89HHg8
	7lzbw+axeUm9x+1/j5k9tlxtZ/Ho27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujKauW4wFa4Qq
	9ne9YWtgPMfXxcjBISFgIjG5xayLkRPIFJO4cG89WxcjF4eQwCJGiZ5XE1kgnBYmic1np7KC
	VLEJWElMbF/FCGKLCOhJNL5vYwKxmQVmMkvc/yUCYgsLZEhsmLeIHcRmEVCVOHluIQuIzSug
	KXFr3mE2EFtUwFNix/aVYDangJbE3YM72UAOEgLq3dxvAVEuKPFj8j0WiPHyEvv2Q5zALKAu
	MWneIuYJjAKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBkfFMegfj
	qgaLQ4wCHIxKPLwCaveDhVgTy4orcw8xSnAwK4nwPt31IFiINyWxsiq1KD++qDQntfgQozQH
	i5I478FW60AhgfTEktTs1NSC1CKYLBMHp1QDI9dP8yN7r5+P23FlU++Pe2X8HBUJDKt75s/9
	+lksyKLzid7eHvPNNxpy9q+4K9ma/0U5cUXgj5+Rp3ic5xjd53aOnjjt6KFIjeN1q77X7Jxz
	8Im1aShfVlpGh+P02x9vrb3XcGfu5QX9AgfPFCgu1VplGzsrW3L1xma9Us4t4cEv4q4ZH1qS
	UK3EUpyRaKjFXFScCADuRJhLiAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Daniel,

On Monday, July 28, 2014 09:43:02 AM Daniel Lezcano wrote:
> On 07/09/2014 07:17 PM, Bartlomiej Zolnierkiewicz wrote:
> > Hi,
> >
> > This patch series adds support for AFTR idle mode on boards with
> > secure firmware enabled and allows EXYNOS cpuidle driver usage on
> > Exynos4x12 SoCs.
> >
> > It has been tested on Trats2 board (using Exynos4412 SoC with secure
> > firmware enabled) on which AFTR mode reduces power consumption by ~12%
> > when EXYNOS cpuidle driver is enabled (in both cases the default
> > exynos_defconfig config is used and CPU1-3 are offlined).
> 
> 
> Hi Bartlomiej,
> 
> what is the status of this patchset ? Is it supposed to land for 3.17 ?

I posted v4 yesterday:
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35197.html

When it comes to merging the patchset for 3.17 it is up to Kukjin.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> Thanks
> 
>    -- Daniel
> 
> > v3:
> > - rebased on top of next-20140708 +
> >    http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32809.html
> >    (with rejects fixed)
> >    http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32808.html
> >    http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32991.html
> >    (with rejects fixed in patch #2)
> > - addressed review comments from Tomasz Figa and Daniel Lezcano
> >
> > Best regards,
> > --
> > Bartlomiej Zolnierkiewicz
> > Samsung R&D Institute Poland
> > Samsung Electronics
> >
> >
> > Bartlomiej Zolnierkiewicz (4):
> >    ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros by static inlines
> >    ARM: EXYNOS: add AFTR mode support to firmware do_idle method
> >    ARM: EXYNOS: cpuidle: add secure firmware support to AFTR mode code
> >    ARM: EXYNOS: cpuidle: allow driver usage on Exynos4x12 SoCs
> >
> >   arch/arm/include/asm/firmware.h  |  2 +-
> >   arch/arm/mach-exynos/common.h    |  7 ++++++-
> >   arch/arm/mach-exynos/exynos.c    |  3 ++-
> >   arch/arm/mach-exynos/firmware.c  | 36 ++++++++++++++++++++++++++----------
> >   arch/arm/mach-exynos/pm.c        | 39 +++++++++++++++++++++++++++++----------
> >   drivers/cpuidle/cpuidle-exynos.c |  6 +++---
> >   6 files changed, 67 insertions(+), 26 deletions(-)

