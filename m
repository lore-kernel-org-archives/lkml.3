Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaJVGgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:36:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41303 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaJVGgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:36:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokx2bKYX3-+UdXkVdvcEgqn9DdN8QUKhY9ohFiA5DCH6A@mail.gmail.com>
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
 <1413958051-7103-5-git-send-email-mturquette@linaro.org> <CAKohpokx2bKYX3-+UdXkVdvcEgqn9DdN8QUKhY9ohFiA5DCH6A@mail.gmail.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Tue, 21 Oct 2014 23:35:44 -0700
Message-ID: <CAPtuhTh04=jj48ZpN4Eb24aoh-t8dKA0UEGgDBxHt1sV-NtM3g@mail.gmail.com>
Subject: Re: [PATCH RFC 4/7] cpufreq: add per-governor private data
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        kamalesh <kamalesh@linux.vnet.ibm.com>, riel <riel@redhat.com>,
        efault@gmx.de, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 11:26 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 22 October 2014 11:37, Mike Turquette <mturquette@linaro.org> wrote:
>> Cc: Viresh Kumar <viresh.kumar@linaro.org>
>> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
>> Signed-off-by: Mike Turquette <mturquette@linaro.org>
>> ---
>>  include/linux/cpufreq.h | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
>> index 138336b..91d173c 100644
>> --- a/include/linux/cpufreq.h
>> +++ b/include/linux/cpufreq.h
>> @@ -115,6 +115,9 @@ struct cpufreq_policy {
>>
>>         /* For cpufreq driver's internal use */
>>         void                    *driver_data;
>> +
>> +       /* For cpufreq governor's internal use */
>> +       void                    *gov_data;
>
> Its already there: governor_data ..
>
> Am I missing something ?

Oops. Thats what I get for hacking while jetlagged. Please disregard the noise.

Regards,
Mike
