Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763251Ab3DCJ1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:27:24 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:62810 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763231Ab3DCJ1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:27:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpon+wk_F0E2oJ_VOj7EKZ0mVbis1-gPSr-T9zLsMC_XohA@mail.gmail.com>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
	<918ff6cc407525d682817cf736347ec572e0316d.1364205812.git.viresh.kumar@linaro.org>
	<CAKohpon+wk_F0E2oJ_VOj7EKZ0mVbis1-gPSr-T9zLsMC_XohA@mail.gmail.com>
Date: Wed, 3 Apr 2013 14:57:17 +0530
Message-ID: <CAKohpom_W8cTA3L80ozcq4HkFaHuuPSNrrFKSFmocorfPra_Cw@mail.gmail.com>
Subject: Re: [PATCH 8/9] cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-samsung-soc@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 March 2013 09:23, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 25 March 2013 15:41, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> This patch moves cpufreq driver of Samsung's ARM based s3c24xx platform to
>> drivers/cpufreq.
>>
>> Cc: Ben Dooks <ben-linux@fluff.org>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Cc: linux-samsung-soc@vger.kernel.org
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>  arch/arm/Kconfig                                   | 46 ---------------
>>  arch/arm/mach-s3c24xx/Kconfig                      | 66 +++++++++-------------
>>  arch/arm/mach-s3c24xx/Makefile                     |  6 --
>>  arch/arm/mach-s3c24xx/{ => include/mach}/s3c2412.h |  0
>>  arch/arm/mach-s3c24xx/iotiming-s3c2412.c           |  2 +-
>>  arch/arm/plat-samsung/include/plat/cpu-freq-core.h | 10 ++--
>>  arch/arm/plat-samsung/include/plat/cpu-freq.h      |  6 +-
>>  drivers/cpufreq/Kconfig.arm                        | 58 +++++++++++++++++++
>>  drivers/cpufreq/Makefile                           |  5 ++
>>  .../cpufreq/s3c2410-cpufreq.c                      |  0
>>  .../cpufreq/s3c2412-cpufreq.c                      |  3 +-
>>  .../cpufreq/s3c2440-cpufreq.c                      |  0
>>  .../cpufreq/s3c24xx-cpufreq-debugfs.c              |  0
>>  .../cpufreq.c => drivers/cpufreq/s3c24xx-cpufreq.c |  0
>>  14 files changed, 100 insertions(+), 102 deletions(-)
>>  rename arch/arm/mach-s3c24xx/{ => include/mach}/s3c2412.h (100%)
>>  rename arch/arm/mach-s3c24xx/cpufreq-s3c2410.c => drivers/cpufreq/s3c2410-cpufreq.c (100%)
>>  rename arch/arm/mach-s3c24xx/cpufreq-s3c2412.c => drivers/cpufreq/s3c2412-cpufreq.c (99%)
>>  rename arch/arm/mach-s3c24xx/cpufreq-s3c2440.c => drivers/cpufreq/s3c2440-cpufreq.c (100%)
>>  rename arch/arm/mach-s3c24xx/cpufreq-debugfs.c => drivers/cpufreq/s3c24xx-cpufreq-debugfs.c (100%)
>>  rename arch/arm/mach-s3c24xx/cpufreq.c => drivers/cpufreq/s3c24xx-cpufreq.c (100%)
>
> Ben/Kukjin,
>
> Can i have your View or Ack for this patch?

Ping!!
