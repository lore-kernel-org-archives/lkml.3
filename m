Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab3AQRyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:54:32 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:54350 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab3AQRya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:54:30 -0500
MIME-Version: 1.0
In-Reply-To: <CADGdYn7SpsaJ54OoxuUw3XnEpdi+qReEHw2wX=3rTQ-f2edNUg@mail.gmail.com>
References: <1353937640-9939-1-git-send-email-amit.kachhap@linaro.org>
	<CADGdYn7SpsaJ54OoxuUw3XnEpdi+qReEHw2wX=3rTQ-f2edNUg@mail.gmail.com>
Date: Thu, 17 Jan 2013 09:47:36 -0800
X-Google-Sender-Auth: knMylObW4i8Bai4uyWHXED7_tTA
Message-ID: <CADGdYn6UqNhBmZxcU9k+=K5zZV8rBa6LtJJF0kNzd=RpzJ8B9g@mail.gmail.com>
Subject: Re: [PATCH V2 0/3] thermal: Add support for interrupt based
 notification to thermal layer
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jonghwa3.lee@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui,

Any update?
Please merge these patch series as they have many critical fixes.

Thanks,
Amit Daniel



On Sun, Jan 6, 2013 at 3:57 PM, amit daniel kachhap
<amit.daniel@samsung.com> wrote:
> Hi Rui,
>
> Any comment on these patches? These are based on new quick cooling
> macros introduced.
> Also my linaro ID is not valid so using samsung ID.
>
> Thanks,
> Amit Daniel
>
> On Mon, Nov 26, 2012 at 5:47 AM, Amit Daniel Kachhap
> <amit.kachhap@linaro.org> wrote:
>> Changes since V1: Used the new thermal trend type macro
>>
>> The patch submitted by Jonghwa Lee (https://patchwork.kernel.org/patch/1683441/)
>> adds support for interrupt based notification to thermal layer. This is a good
>> feature but the current code need more fixes to support that feature so using 2 new thermal
>> trend type to implement this feature and some falling interrupt fixes.
>>
>> All these patches are based on thermal maintainer thermal branch.
>> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git thermal
>>
>> Amit Daniel Kachhap (2):
>>   thermal: exynos: Miscellaneous fixes to support falling threshold
>>     interrupt
>>   thermal: exynos: Use the new thermal trend type for quick cooling
>>     action.
>>
>> Jonghwa Lee (1):
>>   Thermal: exynos: Add support for temperature falling interrupt.
>>
>>  drivers/thermal/exynos_thermal.c             |  108 +++++++++++++++-----------
>>  include/linux/platform_data/exynos_thermal.h |    3 +
>>  2 files changed, 67 insertions(+), 44 deletions(-)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
