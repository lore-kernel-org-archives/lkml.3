Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3BVF5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 00:57:15 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:43641 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab3BVF5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 00:57:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpokKCrvMYWQCRWccDJHbBNO7km5-vP=d3TwhDyU7HGX-YA@mail.gmail.com>
References: <51253715.7080600@semaphore.gr>
	<CAOh2x=mD4DbEH245xsceS1wyhmrRPpB2LeJ9Mh+WGHUA+bZprA@mail.gmail.com>
	<512605A1.8090106@semaphore.gr>
	<CAOh2x=m82jKMf+xgg+fjnCUHLpCQ_NgYqw4auyAidokt_z=uOw@mail.gmail.com>
	<51265BC6.8030601@semaphore.gr>
	<CAKohpokKCrvMYWQCRWccDJHbBNO7km5-vP=d3TwhDyU7HGX-YA@mail.gmail.com>
Date: Fri, 22 Feb 2013 11:27:09 +0530
X-Google-Sender-Auth: n-7l754Wqgl0herFokdx7tR39to
Message-ID: <CAOh2x==cjXGqm0+y_-_Zqc1W5f9Gny7gc=CbR=JRJxXOmg4iWA@mail.gmail.com>
Subject: Re: [PATCH v3 linux-next] cpufreq: ondemand: Calculate gradient of
 CPU load to early increase frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Stratos Karafotis <stratosk@semaphore.gr>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 7:26 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 21 February 2013 23:09, Stratos Karafotis <stratosk@semaphore.gr> wrote:

>> Instead of checking only the absolute value of CPU load_freq to increase
>> frequency, we detect forthcoming CPU load rise and increase frequency
>> earlier.
>>
>> Every sampling rate, we calculate the gradient of load_freq. If it is
>> too steep we assume that the load most probably will go over
>> up_threshold in next iteration(s) and we increase frequency immediately.
>>
>> New tuners are introduced:
>> - early_demand: to enable this functionality (disabled by default).
>> - grad_up_threshold: over this gradient of load we will increase
>> frequency immediately.
>>
>> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Rafael,

I applied it here with my Ack over my patches, for getting a run by
"kbuild test robot".

http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-for-3.10
