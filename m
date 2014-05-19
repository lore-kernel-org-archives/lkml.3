Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaESGQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:16:14 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:54150 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaESGQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:16:11 -0400
MIME-Version: 1.0
In-Reply-To: <1400144805.2273.34.camel@rzhang1-toshiba>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
	<1400144805.2273.34.camel@rzhang1-toshiba>
Date: Mon, 19 May 2014 11:46:10 +0530
Message-ID: <CADGdYn5S67Sd8ON5YHiUvqiw7ypXqV3n4VURheEJsStWinR85w@mail.gmail.com>
Subject: Re: [PATCH 00/10] thermal: exynos: various cleanups
From: Amit Kachhap <amit.kachhap@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/14, Zhang Rui <rui.zhang@intel.com> wrote:
> On 一, 2014-05-05 at 13:15 +0200, Bartlomiej Zolnierkiewicz wrote:
>> Hi,
>>
>> This patch series contains various cleanups for EXYNOS thermal
>> driver.  Overall it decreases driver's LOC by 13%.  It is based
>> on next-20140428 kernel.  It should not cause any functionality
>> changes.
>>
> Amit,
>
> what do you think of this patch set?
>
> thanks,
> rui

I agreed to many of the cleanups in the patch but tmu controller
features should be retained as they will allow adding quick soc
support and also avoid unnecessary churning of code in the future.

Thanks,
Amit

>> Best regards,
>> --
>> Bartlomiej Zolnierkiewicz
>> Samsung R&D Institute Poland
>> Samsung Electronics
>>
>>
>> Bartlomiej Zolnierkiewicz (10):
>>   thermal: exynos: remove unused struct exynos_tmu_registers entries
>>   thermal: exynos: remove unused defines
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
>>  drivers/thermal/samsung/exynos_tmu.c            | 181
>> ++++--------------------
>>  drivers/thermal/samsung/exynos_tmu.h            |  86 +----------
>>  drivers/thermal/samsung/exynos_tmu_data.c       |  40 +-----
>>  drivers/thermal/samsung/exynos_tmu_data.h       |  32 +----
>>  5 files changed, 37 insertions(+), 303 deletions(-)
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
