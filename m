Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934951Ab3DHJQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:16:37 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:48446 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934388Ab3DHJQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:16:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=CFTo2UCnECeeuKdz34cuedV_tqn7zGA9bzU_PiJ46qg@mail.gmail.com>
References: <1365409058-32643-1-git-send-email-amit.daniel@samsung.com>
	<1365409058-32643-2-git-send-email-amit.daniel@samsung.com>
	<CAKohpo=CFTo2UCnECeeuKdz34cuedV_tqn7zGA9bzU_PiJ46qg@mail.gmail.com>
Date: Mon, 8 Apr 2013 14:46:33 +0530
Message-ID: <CAKohpo=t_YTCTRCfnwQ+GPF=frsTGDigT3RZHJuVQ+R+YZU7Hg@mail.gmail.com>
Subject: Re: [PATCH V6 1/4] cpufreq: exynos: Add cpufreq driver for exynos5440
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>, cpufreq@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 April 2013 14:17, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 8 April 2013 13:47, Amit Daniel Kachhap <amit.daniel@samsung.com> wrote:
>
>> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
>> index f3f3b14..bce2195 100644
>> --- a/drivers/cpufreq/Kconfig.arm
>> +++ b/drivers/cpufreq/Kconfig.arm
>> @@ -42,6 +42,15 @@ config ARM_EXYNOS5250_CPUFREQ
>>           This adds the CPUFreq driver for Samsung EXYNOS5250
>>           SoC.
>>
>> +config ARM_EXYNOS5440_CPUFREQ
>> +       def_bool SOC_EXYNOS5440
>> +       depends on HAVE_CLK && PM_OPP && OF
>
> Don't you need a depend on your Soc or mach or arch? Don't send another
> version for this now.. Just send a new patch over this patchset.

Sorry, i overlooked def_bool... This comments stands invalid.
