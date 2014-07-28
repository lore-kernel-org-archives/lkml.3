Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaG1PBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:01:01 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:43963 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaG1PAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:00:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140728143759.GA17837@developer>
References: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
	<20140728143759.GA17837@developer>
Date: Mon, 28 Jul 2014 20:30:53 +0530
X-Google-Sender-Auth: bH0SBlmDuCcTB350UBQxhZeeaVw
Message-ID: <CADGdYn6EN-evo2KCjFfQ2h8gLoop=xTJZO3fnNxBxM9067tjxg@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] thermal: exynos: various cleanups
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

Hi Eduardo,

Please reject this entire series as this is not re-based recently.
Actually two point trimming which this series seeks to remove is used
by exynos3250 and is in Rui's tree
(https://git.kernel.org/cgit/linux/kernel/git/rzhang/linux.git/commit/?h=next&id=1fe56dc16a3dab400206443f70ae158c8f595c42).

Thanks,
Amit D


On Mon, Jul 28, 2014 at 8:07 PM, Eduardo Valentin <edubezval@gmail.com> wrote:
> On Tue, Jun 17, 2014 at 07:27:16PM +0200, Bartlomiej Zolnierkiewicz wrote:
>> Hi,
>>
>> This patch series contains various cleanups for EXYNOS thermal
>> driver.  Overall it decreases driver's LOC by 12%.  It is based
>> on next-20140617 kernel.  It should not cause any functionality
>> changes.
>>
>> Changes since v1:
>> - synced patches against next-20140617
>> - merged patch "thermal: exynos: remove unused defines" into
>>   "thermal: exynos: remove unused struct exynos_tmu_registers
>>   entries" one (per request from Eduardo)
>> - improved patch descriptions for patches #1-5
>> - fixed documentation for pdata->gain and pdata->reference_voltage
>> - added Reviewed-by from Amit to patches #6, #7 and #10
>> - added missing Acked-by from Kyungmin Park
>
> Pulled the series.
>
> Thanks.
>
>>
>> Best regards,
>> --
>> Bartlomiej Zolnierkiewicz
>> Samsung R&D Institute Poland
>> Samsung Electronics
>>
>>
>> Bartlomiej Zolnierkiewicz (9):
>>   thermal: exynos: remove unused struct exynos_tmu_registers entries
>>   thermal: exynos: remove dead code for HW_MODE calibration
>>   thermal: exynos: remove dead code for TYPE_TWO_POINT_TRIMMING
>>     calibration
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
>>  drivers/thermal/samsung/exynos_tmu.c            | 181 ++++--------------------
>>  drivers/thermal/samsung/exynos_tmu.h            |  90 +-----------
>>  drivers/thermal/samsung/exynos_tmu_data.c       |  64 +--------
>>  drivers/thermal/samsung/exynos_tmu_data.h       |  33 +----
>>  5 files changed, 41 insertions(+), 328 deletions(-)
>>
>> --
>> 1.8.2.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
