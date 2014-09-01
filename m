Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaIAKxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:53:37 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:55995 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaIAKxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:53:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140828144921.GB18194@developer>
References: <1406826667-2289-1-git-send-email-b.zolnierkie@samsung.com>
	<20140828144921.GB18194@developer>
Date: Mon, 1 Sep 2014 16:23:34 +0530
X-Google-Sender-Auth: Gbv3utWy7d3f7Ujc8mOLMxxkGwo
Message-ID: <CADGdYn7NzwJKuO1DG2OJdWwd_keZbUJXY=+XeHhf1e+xcSvoVw@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] thermal: exynos: various cleanups
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 8:19 PM, Eduardo Valentin <edubezval@gmail.com> wrote:
> Amit,
>
> On Thu, Jul 31, 2014 at 07:10:58PM +0200, Bartlomiej Zolnierkiewicz wrote:
>> Hi,
>>
>> This patch series contains various cleanups for EXYNOS thermal
>> driver.  Overall it decreases driver's LOC by 9%.  It is based
>> on next-20140731 kernel.  It should not cause any functionality
>> changes.
>>
>
> Did you have the time to test this series?

Hi Eduardo/Bartlomiej,

For the whole series tested on exynos5250 based arndale board.
Tested-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Sorry for the delay as I was busy in some internal work.

Thanks,
Amit D
>
>> Changes since v2 (https://lkml.org/lkml/2014/6/17/436):
>> - synced patches against next-20140731
>> - dropped patch "thermal: exynos: remove dead code for
>>   TYPE_TWO_POINT_TRIMMING calibration" (newly added Exynos3250
>>   SoC support uses TYPE_TWO_POINT_TRIMMING calibration)
>> - updated patch description for patch #2
>> - dropped Reviewed-by from Amit from patch #8 (due to changed
>>   scope of the patch)
>>
>> Changes since v1 (https://lkml.org/lkml/2014/5/5/194):
>> - synced patches against next-20140617
>> - merged patch "thermal: exynos: remove unused defines" into
>>   "thermal: exynos: remove unused struct exynos_tmu_registers
>>   entries" one (per request from Eduardo)
>> - improved patch descriptions for patches #1-5
>> - fixed documentation for pdata->gain and pdata->reference_voltage
>> - added Reviewed-by from Amit to patches #6, #7 and #10
>> - added missing Acked-by from Kyungmin Park
>>
>> Best regards,
>> --
>> Bartlomiej Zolnierkiewicz
>> Samsung R&D Institute Poland
>> Samsung Electronics
>>
>>
>> Bartlomiej Zolnierkiewicz (8):
>>   thermal: exynos: remove unused struct exynos_tmu_registers entries
>>   thermal: exynos: remove dead code for HW_MODE calibration
>>   thermal: exynos: remove redundant pdata checks from
>>     exynos_tmu_initialize()
>>   thermal: exynos: remove redundant threshold_code checks from
>>     exynos_tmu_initialize()
>>   thermal: exynos: simplify temp_to_code() and code_to_temp()
>>   thermal: exynos: cache non_hw_trigger_levels in pdata
>>   thermal: exynos: remove redundant pdata checks from
>>     exynos_tmu_control()
>>   thermal: exynos: remove identical values from exynos*_tmu_registers
>>     structures
>>
>>  drivers/thermal/samsung/exynos_thermal_common.h |   1 -
>>  drivers/thermal/samsung/exynos_tmu.c            | 126 +++++-------------------
>>  drivers/thermal/samsung/exynos_tmu.h            |  74 +-------------
>>  drivers/thermal/samsung/exynos_tmu_data.c       |  56 ++---------
>>  drivers/thermal/samsung/exynos_tmu_data.h       |  31 +-----
>>  5 files changed, 35 insertions(+), 253 deletions(-)
>>
>> --
>> 1.8.2.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
