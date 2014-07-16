Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934621AbaGPQB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:01:57 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:42306 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934480AbaGPQBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:01:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=Z5gEHOC5q40q8dfQfoNP5-WyhjG1arV99zJiG2c+6Xg@mail.gmail.com>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<CAKohpomRttWnCBGEpR3cVsGYniJSnjWUnvtbg21AiYyrUnDjGw@mail.gmail.com>
	<53B4B0B3.9080000@codeaurora.org>
	<CAKohponRv6+rzJnO4cYFhXn6On1+4-KoxFSA2iU_nz130gvsug@mail.gmail.com>
	<20140703221609.11380.6884@quantum>
	<CAKohpomNv_xvcmx03pb8nj=3O33Qt-2Dj2B1q3U46mv5EBtUjA@mail.gmail.com>
	<CAKohpo=Z5gEHOC5q40q8dfQfoNP5-WyhjG1arV99zJiG2c+6Xg@mail.gmail.com>
Date: Wed, 16 Jul 2014 21:31:54 +0530
Message-ID: <CAKohpo=bUMKa752fBXZTb0WPYMfJtuR5uk7z-YaXYV63fhJWtg@mail.gmail.com>
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Tomasz Figa <t.figa@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Rob Herring <rob.herring@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Simon Horman <horms@verge.net.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ing Thomas,

On 8 July 2014 10:20, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 4 July 2014 09:51, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> Yeah, having something like what you suggested from DT is the perfect
>> solution to get over this. The only reason why I am not touching that here
>> is to not delay other patches just because of that.
>>
>> There are separate threads going on for that and probably somebody
>> else was trying to push for that.
>>
>> That's it, nothing more. I would definitely like to use those bindings instead
>>  of the crazy routines we are trying here, once that is finalized :)
>
> Do we have some kind of agreement for this temporary solution? Anyways
> I will kick the other thread again to resolve the bindings soon.

Hi Mike/Rafael,

Thomas has a dependency on the patch adding "find_siblings()":
http://www.spinics.net/lists/arm-kernel/msg348080.html

Would it be fine to get this temporary solution (Only within cpufreq-cpu0
file, so that it doesn't become an API) for now and updating it later once
bindings are closed?

I have tried pinging on the other thread as well, but no one replied.
And it looks those bindings are going to take some time to settle.

--
viresh
