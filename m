Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaDZLfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 07:35:45 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:33087 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751255AbaDZLfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 07:35:41 -0400
Message-ID: <535B9A09.9060902@semaphore.gr>
Date: Sat, 26 Apr 2014 14:35:37 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v5 2/8] cpufreq: Use cpufreq_for_each_* macros for frequency
 table iteration
References: <535AC26A.1000006@semaphore.gr> <CA+V-a8sg9sBi5mf9KoFWrCJjw6WN+tGrb=bgJwfV3VDZ2DGYig@mail.gmail.com>
In-Reply-To: <CA+V-a8sg9sBi5mf9KoFWrCJjw6WN+tGrb=bgJwfV3VDZ2DGYig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On 26/04/2014 12:57 μμ, Prabhakar Lad wrote:
> Hi Stratos,
> 
> Thanks for the patch,
> 
> On Sat, Apr 26, 2014 at 1:45 AM, Stratos Karafotis
> <stratosk@semaphore.gr> wrote:
>> The cpufreq core now supports the cpufreq_for_each_entry and
>> cpufreq_for_each_valid_entry macros helpers for iteration over the
>> cpufreq_frequency_table, so use them.
>>
>> It should have no functional changes.
>>
>> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> 
> For patches 1 & 2:  Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> and for patch 3: Acked-and-tested-by: Lad, Prabhakar
> <prabhakar.csengg@gmail.com>
> 
> Thanks,
> --Prabhakar lad
> 

Thank you very much!


Stratos Karafotis


