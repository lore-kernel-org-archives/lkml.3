Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaDPHEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:04:20 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:58503 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754728AbaDPHER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:04:17 -0400
Message-ID: <534E2B6D.1000902@semaphore.gr>
Date: Wed, 16 Apr 2014 10:04:13 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>, linux-doc@vger.kernel.org,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 0/8] Introduce new cpufreq helper macros
References: <534DB1CC.60407@semaphore.gr> <CAKohpomvmpiYkQAP7Yb=TNxNsXMVh1_MLuK7KQrdEkf15MyvMg@mail.gmail.com>
In-Reply-To: <CAKohpomvmpiYkQAP7Yb=TNxNsXMVh1_MLuK7KQrdEkf15MyvMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/04/2014 07:01 πμ, Viresh Kumar wrote:
> On 16 April 2014 03:55, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>> Hi all,
>>
>> This patch set introduces two freq_table helper macros which
>> can be used for iteration over cpufreq_frequency_table and
>> makes the necessary changes to cpufreq core and drivers that
>> use such an iteration procedure.
>>
>> The motivation was a usage of common procedure to iterate over
>> cpufreq_frequency_table across all drivers and cpufreq core.
>>
>> This was tested on a x86_64 platform.
>> Most files compiled successfully but unfortunately I was not
>> able to compile sh_sir.c pasemi_cpufreq.c and ppc_cbe_cpufreq.c
>> due to lack of cross compiler.
>>
>> Changes v1 -> v2
>>         - Rearrange patches
>>         - Remove redundant braces
>>         - Fix a newly introduced bug in exynos5440
>>         - Use cpufreq_for_each_valid_entry instead of
>> cpufreq_for_each_entry in cpufreq_frequency_table_get_index()
>>         - Drop redundant double ! operator in longhaul and change
> 
> You dropped this !! in thermal stuff and not longhaul :)
> 
>> the pos loop cursor variable to freq_pos.
>>         - Declare pos variable on a separate line
>>
>> Stratos Karafotis (8):
>>   cpufreq: Introduce macros for cpufreq_frequency_table iteration
>>   cpufreq: Use cpufreq_for_each_* macros for frequency table iteration
>>   davinci: da850: Use cpufreq_for_each_entry macro for iteration
>>   mips: lemote 2f: se cpufreq_for_each_entry macro for iteration
>>   mfd: db8500-prcmu: Use cpufreq_for_each_entry macro for iteration
>>   thermal: cpu_cooling: Use cpufreq_for_each_valid_entry macro for
>>     iteration
>>   irda: sh_sir: Use cpufreq_for_each_valid_entry macro for iteration
>>   sh: clk: Use cpufreq_for_each_valid_entry macro for iteration
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 

Thanks!

Stratos
