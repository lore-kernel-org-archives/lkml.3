Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3KASNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:13:35 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:59316 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752343Ab3KASNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:13:33 -0400
Message-ID: <5273EF46.7060703@semaphore.gr>
Date: Fri, 01 Nov 2013 20:13:26 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Henrik Nilsson <Karl.Henrik.Nilsson@gmail.com>
Subject: Re: [PATCH] cpufreq: ondemand: Remove redundant return statement
References: <5272A118.1090908@semaphore.gr> <CAKohponQ+oRYpdYrpKV3=GMh6ACQr+E+WygLHk0mdC+ivjeP_Q@mail.gmail.com> <7457887.jzoQrnelyS@vostro.rjw.lan>
In-Reply-To: <7457887.jzoQrnelyS@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 02:18 AM, Rafael J. Wysocki wrote:
> On Friday, November 01, 2013 12:09:16 AM Viresh Kumar wrote:
>> On 31 October 2013 23:57, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>>> After commit dfa5bb622555d9da0df21b50f46ebdeef390041b
>>> "cpufreq: ondemand: Change the calculation of target frequency",
>>> this return statement is no longer needed.
>>>
>>> Reported-by: Henrik Nilsson <Karl.Henrik.Nilsson@gmail.com>
>>> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
>>> ---
>>>   drivers/cpufreq/cpufreq_ondemand.c | 1 -
>>>   1 file changed, 1 deletion(-)
>>>
>>> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
>>> index 32f26f6..18d4091 100644
>>> --- a/drivers/cpufreq/cpufreq_ondemand.c
>>> +++ b/drivers/cpufreq/cpufreq_ondemand.c
>>> @@ -168,7 +168,6 @@ static void od_check_cpu(int cpu, unsigned int load)
>>>                          dbs_info->rate_mult =
>>>                                  od_tuners->sampling_down_factor;
>>>                  dbs_freq_increase(policy, policy->max);
>>> -               return;
>>>          } else {
>>>                  /* Calculate the next frequency proportional to load */
>>>                  unsigned int freq_next;
>>
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Queued up for 3.13, thanks!
>

Thank you both for your immediate response!

Stratos
