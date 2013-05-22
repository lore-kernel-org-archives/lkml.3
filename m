Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3EVLQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:16:35 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:58895 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3EVLQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:16:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130522122700.104ca5cd@amdc308.digital.local>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
	<CAKohpokXNUmMbk0KOh58-0=sAs7yzD=cQe24eaoArpRSwM__Gg@mail.gmail.com>
	<20130522122700.104ca5cd@amdc308.digital.local>
Date: Wed, 22 May 2013 16:46:31 +0530
Message-ID: <CAKohpo=9dRXb1jjauvhzuje9rOgH82k-3DeL2zqiwHDHOwSo4g@mail.gmail.com>
Subject: Re: [RFC v2 0/3] LAB: Support for Legacy Application Booster governor
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, "Rafael J. Wysocky" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 May 2013 15:57, Lukasz Majewski <l.majewski@samsung.com> wrote:
>> On 3 May 2013 19:37, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:

> I think, that overclocking support is crucial here. As you pointed out
> - ondemand and conservative benefit from it. Therefore, I would urge
>   for its mainline acceptance.
>
> (code for reference)
> http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
>
> In this RFC (patch 1/3), I've decided to put the burden of overclocking
> support to platform code (cpufreq/exynos-cpufreq.c and
> cpufreq/exynos4x12-cpufreq.c).
>
> Those changes aren't intrusive for other boards/archs. Moreover
> overclocking is closely related to processor clocking/power dissipation
> capabilities, so SoC specific code is a good place for it.
>
>
> What DO need a broad acceptance is the overclocking API proposed at:
> include/linux/cpufreq.h
>
> This introduces interface to which others will be bind. It shouldn't be
> difficult to implement overclocking at other SoCs (as it was proposed
> for Exynos).
>
> Feedback is welcome, since I might have overlooked oddities present at
> other SoCs.

Hi..

I am not talking about the minute details here... for example I didn't like
the way overclocking support is implemented... It has to be a bit more
framework oriented then driver...

What I am thinking right now is if it is worth to add both the features
you are trying. i.e. overclocking and LAB..

So, requested you to give some figures... of ondemand with and without
overclocking... Leave LAB for now...

Then we can give LAB a try with above...
