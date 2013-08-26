Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab3HZPXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:23:07 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:43035 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab3HZPXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:23:05 -0400
MIME-Version: 1.0
In-Reply-To: <20581731.mdSQ720dHi@vostro.rjw.lan>
References: <CAKohponkO6oZrvrsUGVK0uUbAM5wse7eHd7udtWkab7y2aatGA@mail.gmail.com>
	<20581731.mdSQ720dHi@vostro.rjw.lan>
Date: Mon, 26 Aug 2013 23:23:03 +0800
Message-ID: <CAOLK0pzg5VwDBLbUFU8J8wujxUazPgFC-+C4+Z6AMLYv7KcOtw@mail.gmail.com>
Subject: Re: [Query] CPUFreq: Why do we need policy->user_policy?
From: Lan Tianyu <lantianyu1986@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/26 Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday, August 26, 2013 08:00:52 PM Viresh Kumar wrote:
>> Hi Rafael,
>
> Hi,
>
>> I am almost done with cleanup of drivers and am back at cpufreq core.. :)
>> I got to this structure: struct cpufreq_real_policy;
>>
>> And I am not able to understand what's the need for this structure?
>> Can you let me know? Before I try to get rid of it :)
>
> Honestly, I don't remember from the top of my head.

So far as I know, it stores some user's config and cpufreq_update_policy()
bases on the data in the struct to start a new policy. Cpu thermal driver
£¨/driver/thermal/cpu_cooling.c£©also will its value to update freq policy
when receive a cpufreq policy adjust notification.

>
> Thanks,
> Rafael
>
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards
Tianyu Lan
