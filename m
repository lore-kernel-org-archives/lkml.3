Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3LRLLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:11:40 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:34201 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3LRLLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:11:37 -0500
MIME-Version: 1.0
In-Reply-To: <52B02D04.4050905@nvidia.com>
References: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com>
	<1386229462-3474-3-git-send-email-bilhuang@nvidia.com>
	<CAKohponns4B+BPPum3EN6EuXx6U+6MzOa50gMdR1BNBtxMNf0Q@mail.gmail.com>
	<52B02D04.4050905@nvidia.com>
Date: Wed, 18 Dec 2013 16:41:35 +0530
Message-ID: <CAKohpom0n8P8goQnsgBnWJwyqCVv_FRX3xKvO1yFW0VUMpMW8w@mail.gmail.com>
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

On 17 December 2013 16:22, bilhuang <bilhuang@nvidia.com> wrote:
> Tegra20 DVFS is a little bit complicated due to the fact that we can't scale
> VDD_CPU directly, there are constraints or relationship to other power rails
> so I don't think it is a good idea to use generic cpufreq-cpu0 driver if
> we're going to support voltage scaling.

But why can't we handle that in a CPU specific regulator code?
