Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab3LSF3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 00:29:24 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:44073 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3LSF3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 00:29:22 -0500
MIME-Version: 1.0
In-Reply-To: <52B28397.5010808@nvidia.com>
References: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com>
	<1386229462-3474-3-git-send-email-bilhuang@nvidia.com>
	<CAKohponns4B+BPPum3EN6EuXx6U+6MzOa50gMdR1BNBtxMNf0Q@mail.gmail.com>
	<52B02D04.4050905@nvidia.com>
	<CAKohpom0n8P8goQnsgBnWJwyqCVv_FRX3xKvO1yFW0VUMpMW8w@mail.gmail.com>
	<52B187F5.7020105@nvidia.com>
	<CAKohpokwhYC4FGnhpZPOGuJ2AM_7vygNk+3S+VpA_eXAexQX7g@mail.gmail.com>
	<52B28397.5010808@nvidia.com>
Date: Thu, 19 Dec 2013 10:59:21 +0530
Message-ID: <CAKohpo=fJTLrN6myq5b9FTSro1m9oN3ep-aMu-3iv0J-S6TpdQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] cpufreq: tegra: Re-model Tegra cpufreq driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: bilhuang <bilhuang@nvidia.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 December 2013 10:56, bilhuang <bilhuang@nvidia.com> wrote:
> I'm not sure virtual regulator for CPU is a good idea, in addition to that,
> we don't have a single SoC OPP table, we need several which are speedo-id
> and process-id dependant, but generic cpufreq-cpu0 is assuming there is only
> one statically

Can't that be handled via DT ?

> for some SoC the frequency table is not fixed, they are
> created at runtime combining our fast and slow CPU frequency table and dvfs
> table. So I'm really not sure is it worth adding so many tweaks in order to
> use the generic cpufreq-cpu0 driver.

Hmm, maybe I got confused because I don't have a clear picture in my mind.
It might be better to go ahead with your implementation for now and after
everything is set, we can choose to use cpufreq-cpu0 if it is worth it.

--
viresh
