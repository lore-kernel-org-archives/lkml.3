Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaBGJe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:34:58 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:46375 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaBGJe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:34:56 -0500
MIME-Version: 1.0
In-Reply-To: <3663519.7JfYNffMTG@amdc1227>
References: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com>
 <1387433191-7861-1-git-send-email-ch.naveen@samsung.com> <3663519.7JfYNffMTG@amdc1227>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Fri, 7 Feb 2014 15:04:35 +0530
Message-ID: <CAHfPSqCDk6bQhC2P4r134AYkqs9mk0msHzfhZ3ZQUNo1JFk7xA@mail.gmail.com>
Subject: Re: [PATCH v12 3/4] thermal: samsung: Add TMU support for Exynos5420 SoCs
To: Tomasz Figa <t.figa@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>, linux-pm@vger.kernel.org,
        rui.zhang@intel.com, eduardo.valentin@ti.com,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        Kukjin Kim <kgene.kim@samsung.com>, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

On 19 December 2013 17:04, Tomasz Figa <t.figa@samsung.com> wrote:
> On Thursday 19 of December 2013 11:36:31 Naveen Krishna Chatradhi wrote:
>> Exynos5420 has 5 TMU channels, the TRIMINFO register is
>> misplaced for TMU channels 2, 3 and 4
>> TRIMINFO at 0x1006c000 contains data for TMU channel 3
>> TRIMINFO at 0x100a0000 contains data for TMU channel 4
>> TRIMINFO at 0x10068000 contains data for TMU channel 2
>>
>> This patch
>> 1 Adds the neccessary register changes and arch information
>>    to support Exynos5420 SoCs.
>> 2. Handles the gate clock for misplaced TRIMINFO register
>> 3. Updates the Documentation at
>>    Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> ---
>> Changes since v11:
>> 1. Added description for clocks in the Documentation
>> 2. corrected the clock name in clk_get() function as per description
>>
>> Changes since v10:
>> 1. using renamed compatible "samsung,exynos5420-tmu-ext-triminfo"
>>    and passing same clock as triminfo_apbif clock for channel 2
>> 2. removed the "exynos5420-tmu-triminfo-clk" compatible
>>  .../devicetree/bindings/thermal/exynos-thermal.txt |   45 ++++++++-
>>  drivers/thermal/samsung/exynos_tmu.c               |   52 +++++++++-
>>  drivers/thermal/samsung/exynos_tmu.h               |    1 +
>>  drivers/thermal/samsung/exynos_tmu_data.c          |   99 ++++++++++++++++++++
>>  drivers/thermal/samsung/exynos_tmu_data.h          |    8 ++
>>  5 files changed, 200 insertions(+), 5 deletions(-)
>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>
> Best regards,
> Tomasz
>
Ping.



-- 
Shine bright,
(: Nav :)
