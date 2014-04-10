Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030640AbaDJM3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:29:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42776 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030452AbaDJM3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:29:44 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-22-53468eb4c5ea
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Kachhap <amit.kachhap@gmail.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] thermal: offer Samsung thermal support only when
 ARCH_EXYNOS is defined
Date: Thu, 10 Apr 2014 14:29:35 +0200
Message-id: <12703899.ZIfn6gkXfr@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <5294A097.3070903@ti.com>
References: <2958660.aJeCDrTTOe@amdc1032>
 <CADGdYn4YQL9-8WCDNWP8x9Gec9sMV09q3OsYPz3tTdMxDGnyvg@mail.gmail.com>
 <5294A097.3070903@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9jQd0tfW7BBlOuGFr8ejeT3WLN/p9M
	Fmeb3rBbXN41h83ic+8RRosZ5/cxWTx52MfmwO6xc9Zddo/Fe14yefRtWcXocfzGdiaPz5vk
	AlijuGxSUnMyy1KL9O0SuDLudB9iKujiqWg4u5GxgfEhZxcjJ4eEgInE43u3WSFsMYkL99az
	dTFycQgJTGeU+Lf1GSuE08IksX7bHzaQKjYBK4mJ7asYQWwRAWWJRee2gtnMAg8ZJY4dUgGx
	hQXiJHbMXgc2lUVAVeLQlm4wm1dAS+LKiz1MILaogKfEju0rwWZyCqhJrDu7BGpZD6PE8k8z
	mCAaBCV+TL7HArFAXmLf/qmsELaOxP7WaWwTGAVmISmbhaRsFpKyBYzMqxhFUwuSC4qT0nMN
	9YoTc4tL89L1kvNzNzGCA/2Z1A7GlQ0WhxgFOBiVeHgPLHMNFmJNLCuuzD3EKMHBrCTCu7bV
	LViINyWxsiq1KD++qDQntfgQozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QDY3NRyZKD
	Os2a684/riqXzTR++23RhoTlF1U3apZ83Bq5/WTNvFNCRh80LvAuzS6TKBCp/vfNXmTvipYX
	u1+5XGnV+vAjeI/hM7WeI9uN23N53h0vWqkv6b1vMUOq/y7m815vZn686GN6+X2R0+GSqTwd
	agJbUznyDx+aKVyyUrzz3Vn/QNPg3UosxRmJhlrMRcWJADYRltJwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Zhang, could you please pick this patch up to your tree?

[ Eduardos's tree hasn't been updated for over 4 months and
  seems to be dead.. ]

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Tuesday, November 26, 2013 09:22:31 AM Eduardo Valentin wrote:
> On 26-11-2013 02:07, Amit Kachhap wrote:
> > On 10/4/13, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> >> Menu for Samsung thermal support is visible on all Samsung
> >> platforms while thermal drivers are currently available only
> >> for EXYNOS SoCs. Fix it by replacing PLAT_SAMSUNG dependency
> >> with ARCH_EXYNOS one.
> >>
> >> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Looks good, so
> > Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> 
> I will be queuing this one in my tree.
> 
> Thanks Bartlomiej.
> 
> > 
> >> ---
> >>  drivers/thermal/Kconfig | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> >> index a709c63..05cf95c 100644
> >> --- a/drivers/thermal/Kconfig
> >> +++ b/drivers/thermal/Kconfig
> >> @@ -198,7 +198,7 @@ source "drivers/thermal/ti-soc-thermal/Kconfig"
> >>  endmenu
> >>
> >>  menu "Samsung thermal drivers"
> >> -depends on PLAT_SAMSUNG
> >> +depends on ARCH_EXYNOS
> >>  source "drivers/thermal/samsung/Kconfig"
> >>  endmenu
> >>
> >> --
> >> 1.8.2.3

