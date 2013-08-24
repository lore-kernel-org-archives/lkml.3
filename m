Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab3HXEUK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 00:20:10 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:38882 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab3HXEUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 00:20:07 -0400
MIME-Version: 1.0
In-Reply-To: <2330969.4ermKsDahJ@vostro.rjw.lan>
References: <cover.1377272740.git.viresh.kumar@linaro.org>
	<2330969.4ermKsDahJ@vostro.rjw.lan>
Date: Sat, 24 Aug 2013 09:50:06 +0530
Message-ID: <CAKohpokQkwYJBp=Bf7jOVk3MU-ziWtUCSyiX_f-JNzkt0F+-Dw@mail.gmail.com>
Subject: Re: [PATCH 00/16] cpufreq: create & use cpufreq_generic_get() routine
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 August 2013 01:10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, August 23, 2013 09:20:35 PM Viresh Kumar wrote:
>> CPUFreq drivers that use clock frameworks interface,i.e. clk_get_rate(), to get
>> CPUs clk rate, has similar sort of code used for most of them.
>>
>> This patchset adds a generic ->get() which will do the same thing for them. All
>> those drivers are required to now is to set .get to cpufreq_generic_get() and
>> set their clk pointer in policy->clk during ->init().
>>
>> Later part of this patchset fixes 17 drivers with this change.
>>
>> That's part 7 of my generic cleanups for CPUFreq core, first six are here:
>
> And that's the last one for 3.13, right?

3.13 is too far, can't promise that really :)
