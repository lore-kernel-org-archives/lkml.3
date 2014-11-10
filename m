Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaKJEwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:52:19 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:61991 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaKJEwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:52:18 -0500
MIME-Version: 1.0
In-Reply-To: <1414161563-16812-13-git-send-email-mikko.perttunen@kapsi.fi>
References: <1414161563-16812-1-git-send-email-mikko.perttunen@kapsi.fi>
	<1414161563-16812-13-git-send-email-mikko.perttunen@kapsi.fi>
Date: Mon, 10 Nov 2014 10:22:15 +0530
Message-ID: <CAKohpo=Kdh2vuvSoQBLdWfZJn3xDezpNBjqM389u45_BdizPXQ@mail.gmail.com>
Subject: Re: [PATCH v5 12/16] cpufreq: tegra: Rename tegra-cpufreq to tegra20-cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mikko Perttunen <mikko.perttunen@kapsi.fi>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mike Turquette <mturquette@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, Vince Hsu <vinceh@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 October 2014 20:09, Mikko Perttunen <mikko.perttunen@kapsi.fi> wrote:
> From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
>
> The Tegra124 will use a different driver for frequency scaling, so
> rename the old driver (which handles only Tegra20) appropriately.
>
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> Signed-off-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
> ---
>  drivers/cpufreq/Kconfig.arm       |   6 +-
>  drivers/cpufreq/Makefile          |   2 +-
>  drivers/cpufreq/tegra-cpufreq.c   | 218 --------------------------------------
>  drivers/cpufreq/tegra20-cpufreq.c | 218 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 222 insertions(+), 222 deletions(-)
>  delete mode 100644 drivers/cpufreq/tegra-cpufreq.c
>  create mode 100644 drivers/cpufreq/tegra20-cpufreq.c

Its just not readable enough.. You should have used: git format-patch -C -M
