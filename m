Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125Ab3DJDWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 23:22:16 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:55081 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933912Ab3DJDWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 23:22:14 -0400
MIME-Version: 1.0
In-Reply-To: <51644855.1090300@semaphore.gr>
References: <ore61p9gvaic2j0fc083dpbd.1364970699079@email.android.com>
	<CAKohponUuwiQ9EiKq66Mgf7zZxonxHs=DNbhx=uydDVB5bed6w@mail.gmail.com>
	<3060957.HxB12olH3c@vostro.rjw.lan>
	<515CBB98.4020607@semaphore.gr>
	<CAKohpomV7uSS1suFKGiGJfGvvqodKHhvc_uO3WsR4jzUg+1o9g@mail.gmail.com>
	<515F2AF3.9050709@semaphore.gr>
	<51644855.1090300@semaphore.gr>
Date: Wed, 10 Apr 2013 08:52:14 +0530
Message-ID: <CAKohponhGA1LCe8Hv7xHk0ULXVVPTgmEY-nKTgpE0w6VmX--Ng@mail.gmail.com>
Subject: Re: [PATCH v3 linux-next] cpufreq: ondemand: Calculate gradient of
 CPU load to early increase frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2013 22:26, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> On 04/05/2013 10:50 PM, Stratos Karafotis wrote:
>>
>> Hi Viresh,
>>
>> On 04/04/2013 07:54 AM, Viresh Kumar wrote:
>>>
>>> Hi Stratos,
>>>
>>> Yes, your results show some improvements. BUT if performance is the only
>>> thing
>>> we were looking for, then we will never use ondemand governor but
>>> performance
>>> governor.
>>>
>>> I suspect this little increase in performance must have increased power
>>> numbers
>>> too (significantly). So, if you can get numbers in the form of
>>> power/performance
>>> with and without your patch, it will be great.
>>>
>>> --
>>> viresh
>>>
>>
>> I run some more tests. I increased the number of iterations to 100 (from
>> 20).
>> I also test for counter 1,000,000 (~4200us), 5,000,000 (~10000us),
>> 15,000,000 (~30000us).
>>
>> This time, I also extracted statistics from cpufreq_stats driver. I think
>> this will be an
>> indication for power consumption. Below the results and attached the
>> program I used for to
>> get these numbers.
>
>
> Any comments would be appreciated.

Sorry, i forgot about this mail earlier..

Your performance numbers look improved but i am still not sure about
power consumption. But as this is not going to be the default settings, i
think we can take this patch.

@Rafael:?
