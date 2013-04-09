Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937243Ab3DIQ47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:56:59 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:40665 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763142Ab3DIQ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:56:57 -0400
Message-ID: <51644855.1090300@semaphore.gr>
Date: Tue, 09 Apr 2013 19:56:53 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 linux-next] cpufreq: ondemand: Calculate gradient of
 CPU load to early increase frequency
References: <ore61p9gvaic2j0fc083dpbd.1364970699079@email.android.com> <CAKohponUuwiQ9EiKq66Mgf7zZxonxHs=DNbhx=uydDVB5bed6w@mail.gmail.com> <3060957.HxB12olH3c@vostro.rjw.lan> <515CBB98.4020607@semaphore.gr> <CAKohpomV7uSS1suFKGiGJfGvvqodKHhvc_uO3WsR4jzUg+1o9g@mail.gmail.com> <515F2AF3.9050709@semaphore.gr>
In-Reply-To: <515F2AF3.9050709@semaphore.gr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 10:50 PM, Stratos Karafotis wrote:
> Hi Viresh,
>
> On 04/04/2013 07:54 AM, Viresh Kumar wrote:
>> Hi Stratos,
>>
>> Yes, your results show some improvements. BUT if performance is the only thing
>> we were looking for, then we will never use ondemand governor but performance
>> governor.
>>
>> I suspect this little increase in performance must have increased power numbers
>> too (significantly). So, if you can get numbers in the form of power/performance
>> with and without your patch, it will be great.
>>
>> --
>> viresh
>>
>
> I run some more tests. I increased the number of iterations to 100 (from 20).
> I also test for counter 1,000,000 (~4200us), 5,000,000 (~10000us), 15,000,000 (~30000us).
>
> This time, I also extracted statistics from cpufreq_stats driver. I think this will be an
> indication for power consumption. Below the results and attached the program I used for to
> get these numbers.

Any comments would be appreciated.

Thanks,
Stratos


