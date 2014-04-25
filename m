Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaDYPLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:11:30 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:59035 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751217AbaDYPLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:11:25 -0400
Message-ID: <535A7B18.9070505@semaphore.gr>
Date: Fri, 25 Apr 2014 18:11:20 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>, Olof Johansson <olof@lixom.net>,
        linuxppc-dev@lists.ozlabs.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 2/8] cpufreq: Use cpufreq_for_each_* macros for frequency
 table iteration
References: <534DB1EB.1080401@semaphore.gr> <5355A327.3020308@semaphore.gr> <CA+V-a8swMCPkf=rwbLOjiqAgpaQ7TZPutTQTh_sSFmbJvHz-1Q@mail.gmail.com>
In-Reply-To: <CA+V-a8swMCPkf=rwbLOjiqAgpaQ7TZPutTQTh_sSFmbJvHz-1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On 25/04/2014 03:31 μμ, Prabhakar Lad wrote:
> Hi Stratos,
> 
> Thanks for the patch.
> 
> On Tue, Apr 22, 2014 at 4:30 AM, Stratos Karafotis
> <stratosk@semaphore.gr> wrote:
>> The cpufreq core now supports the cpufreq_for_each_entry and
>> cpufreq_for_each_valid_entry macros helpers for iteration over the
>> cpufreq_frequency_table, so use them.
>>
>> It should have no functional changes.
>>
> This patch produces following build warning,
> 
> drivers/cpufreq/freq_table.c: In function 'cpufreq_frequency_table_cpuinfo':
> drivers/cpufreq/freq_table.c:36:3: warning: format '%lu' expects
> argument of type 'long unsigned int', but argument 2 has type 'int'
> [-Wformat=]
>    pr_debug("table entry %lu: %u kHz\n", pos - table, freq);

Thanks for this finding.
I will fix it and resend the patch.


Stratos Karafotis


