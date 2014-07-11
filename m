Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaGKOhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:37:45 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:50420 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaGKOhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:37:42 -0400
MIME-Version: 1.0
In-Reply-To: <53BFF132.3020700@nvidia.com>
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
	<1405028569-14253-13-git-send-email-ttynkkynen@nvidia.com>
	<CAKohpom9ORXFiUU4=V+CxgN0ZOFLMEhEjHiU8HsYUYDybNXgHQ@mail.gmail.com>
	<53BFF132.3020700@nvidia.com>
Date: Fri, 11 Jul 2014 20:07:42 +0530
Message-ID: <CAKohpon_YKkRP+iYnUaE14fKmcSx_SfWVHPiA48BGiPTCPHTKA@mail.gmail.com>
Subject: Re: [PATCH 12/13] cpufreq: Add cpufreq driver for Tegra124
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 July 2014 19:44, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
> Sure, I can do the CPU clock parent change first and then instantiate the
> cpufreq-cpu0 driver, like highbank-cpufreq. That'll depend on the patch
> 'cpufreq: cpu0: OPPs can be populated at runtime' from your 'Extend support
> beyond CPU0' series though, any idea when that patch will land in?

So, after your mail I had a chat with Rafael. As this patch happens to be a
fix, we will try to take it into 3.16 only (I am going to send few patches out
of that series separately in few mins). Otherwise 3.17 is where most of it
should go.

Thanks for your agreement to make our life easier :)
