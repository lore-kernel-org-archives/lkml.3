Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab3IBBAd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 21:00:33 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37478 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691Ab3IBBAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 21:00:31 -0400
MIME-Version: 1.0
In-Reply-To: <2163175.MrORytQUnh@vostro.rjw.lan>
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org>
	<11222156.oKTjYXFZjG@vostro.rjw.lan>
	<CAKohpon1VsoUnw=t0c9wQ2Zfva5nnXoKjNNNxLXV7Frto1BFug@mail.gmail.com>
	<2163175.MrORytQUnh@vostro.rjw.lan>
Date: Mon, 2 Sep 2013 06:30:30 +0530
Message-ID: <CAKohpo=CFWH6wCpBQb2fut_duUCY7Ko2JudoV+e6c+wD+d8eFw@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 September 2013 01:57, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> The second tab is one too many, I usually write such things like this:
>
>         if (policy->governor_busy
>             || (policy->governor_enabled && event == CPUFREQ_GOV_START)
>             || ...
>
> Then it is much easier to distinguish the conditional code from the condition
> itself.

I see... I tried to do it this way but got confused again :)
You fix it this time and I will understand it from that :)

--
viresh
