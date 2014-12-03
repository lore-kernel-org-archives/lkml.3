Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaLCJGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:06:51 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45522 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaLCJGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:06:40 -0500
Message-ID: <547ED29C.4010006@linaro.org>
Date: Wed, 03 Dec 2014 10:06:36 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: add MAINTAINERS entry for ARM Exynos cpuidle
 driver
References: <1616359.KRpRrFqxfV@amdc1032> <1466322.AKaPtIKjPo@vostro.rjw.lan>
In-Reply-To: <1466322.AKaPtIKjPo@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 01:08 AM, Rafael J. Wysocki wrote:
> On Tuesday, December 02, 2014 04:41:35 PM Bartlomiej Zolnierkiewicz wrote:
>> Since there has been quite a lot of development going on for
>> ARM Exynos cpuidle driver recently I would like to add separate
>> MAINTAINERS entry for it and add myself as the primary maintainer.
>>
>> The merging process would remain (almost) unchanged with patches
>> going (with my Ack) through Daniel's or Kukjin's tree.
>>
>> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> Daniel, do you want me to apply this, or are you going to do that?

Please apply it.

Thanks !
  -- Daniel

>> ---
>>   MAINTAINERS |   10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> Index: b/MAINTAINERS
>> ===================================================================
>> --- a/MAINTAINERS	2014-11-27 18:02:51.988225868 +0100
>> +++ b/MAINTAINERS	2014-12-02 15:56:52.792997513 +0100
>> @@ -2701,6 +2701,16 @@ T:	git git://git.kernel.org/pub/scm/linu
>>   S:	Maintained
>>   F:	drivers/cpuidle/cpuidle-big_little.c
>>
>> +CPUIDLE DRIVER - ARM EXYNOS
>> +M:	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> +M:	Daniel Lezcano <daniel.lezcano@linaro.org>
>> +M:	Kukjin Kim <kgene@kernel.org>
>> +L:	linux-pm@vger.kernel.org
>> +L:	linux-samsung-soc@vger.kernel.org
>> +S:	Supported
>> +F:	drivers/cpuidle/cpuidle-exynos.c
>> +F:	arch/arm/mach-exynos/pm.c
>> +
>>   CPUIDLE DRIVERS
>>   M:	Rafael J. Wysocki <rjw@rjwysocki.net>
>>   M:	Daniel Lezcano <daniel.lezcano@linaro.org>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

