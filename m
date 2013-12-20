Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3LTKdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:33:51 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:60885 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab3LTKdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:33:47 -0500
MIME-Version: 1.0
In-Reply-To: <52B41B18.30302@nvidia.com>
References: <1387451926-21373-1-git-send-email-bilhuang@nvidia.com>
	<CAKohpomCPJYd+d_NnM9gxwQ7bH6C6=iLxbiWZbfNcjZ8Bi+2wA@mail.gmail.com>
	<52B41B18.30302@nvidia.com>
Date: Fri, 20 Dec 2013 16:03:47 +0530
Message-ID: <CAKohpontQwTc4KP7XMvtkvS2sQTyF+ngXnXfbJ1ev+MLEp-H0g@mail.gmail.com>
Subject: Re: [PATCH v5 1/1] cpufreq: tegra: Re-model Tegra20 cpufreq driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: bilhuang <bilhuang@nvidia.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 December 2013 15:55, bilhuang <bilhuang@nvidia.com> wrote:
> Don't you think it worth creating a file here so this can be shared to
> arm64?

We will see how to handle virtual devices when we will start getting
arm64 SoCs. Probably we might end up writing a single file in cpufreq,
if required, that will create virtual devices for every arm64 platform..

So, some people might use it and others wouldn't.. But no platform
specific files for such stuff. So, the best we can do for now is to move
these to platform code as we are talking about arm32 SoC's for now
which do have a mach-* directory..
