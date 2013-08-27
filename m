Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3H0OEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:04:54 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:46928 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3H0OEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:04:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=ZKA6ieg9BrVRCRL+_7uiPfb2tWMO0_VOYx0m=Sv4+xQ@mail.gmail.com>
References: <CAKohponkO6oZrvrsUGVK0uUbAM5wse7eHd7udtWkab7y2aatGA@mail.gmail.com>
	<20581731.mdSQ720dHi@vostro.rjw.lan>
	<CAOLK0pzg5VwDBLbUFU8J8wujxUazPgFC-+C4+Z6AMLYv7KcOtw@mail.gmail.com>
	<CAKohpo=ZKA6ieg9BrVRCRL+_7uiPfb2tWMO0_VOYx0m=Sv4+xQ@mail.gmail.com>
Date: Tue, 27 Aug 2013 22:04:52 +0800
Message-ID: <CAOLK0pztfCd9ov297t0CW0C5S2iOSb9FJFHq9ycqwYGRiyifmA@mail.gmail.com>
Subject: Re: [Query] CPUFreq: Why do we need policy->user_policy?
From: Lan Tianyu <lantianyu1986@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/27 Viresh Kumar <viresh.kumar@linaro.org>:
> On 26 August 2013 20:53, Lan Tianyu <lantianyu1986@gmail.com> wrote:
>> So far as I know, it stores some user's config and cpufreq_update_policy()
>> bases on the data in the struct to start a new policy. Cpu thermal driver
>> £¨/driver/thermal/cpu_cooling.c£©also will its value to update freq policy
>> when receive a cpufreq policy adjust notification.
>
> Yeah, but how are these different from policy->min/max/policy/governor?
> Why do we need to replicate this information?

>From my understanding.policy->min/max may be modified by some drivers
but the user_policy only store user space config and should not be changed
by other reason.  :)

-- 
Best regards
Tianyu Lan
