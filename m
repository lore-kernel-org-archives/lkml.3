Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaDOLCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:02:32 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:56241 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750919AbaDOLC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:02:29 -0400
Message-ID: <534D11C2.3080206@semaphore.gr>
Date: Tue, 15 Apr 2014 14:02:26 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/20] cpufreq: exynos5440: Use cpufreq_for_each_entry
 macro for iteration
References: <534C4E7E.4090806@semaphore.gr> <CAKohpokfsR3soykZbtH4-L=4TC6Oab=jyzUr=W-EfkRFfefRDQ@mail.gmail.com>
In-Reply-To: <CAKohpokfsR3soykZbtH4-L=4TC6Oab=jyzUr=W-EfkRFfefRDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/2014 08:44 πμ, Viresh Kumar wrote:
> On 15 April 2014 02:39, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> 
>> diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
> 
>>  static void exynos_enable_dvfs(unsigned int cur_frequency)
>>  {
>> -       unsigned int tmp, i, cpu;
>> +       unsigned int tmp, cpu;
>>         struct cpufreq_frequency_table *freq_table = dvfs_info->freq_table;
>> +       struct cpufreq_frequency_table *pos;
> 
> Merge above two.
> 

Then the line will be 82 characters long.
Do you mind to keep it as is?


Stratos
