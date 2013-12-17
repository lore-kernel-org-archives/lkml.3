Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3LQG0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 01:26:32 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:40501 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3LQG0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 01:26:30 -0500
MIME-Version: 1.0
In-Reply-To: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com>
References: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com>
Date: Tue, 17 Dec 2013 11:56:29 +0530
Message-ID: <CAKohponJAU20MQ92y4VaOXbsOOmxz6K=349KCq91c5=P=zQOQQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Remodel Tegra cpufreq drivers to support Tegra
 series SoC
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Bill Huang <bilhuang@nvidia.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Warren <swarren@wwwdotorg.org>, thierry.reding@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 December 2013 13:14, Bill Huang <bilhuang@nvidia.com> wrote:
> This patch series remodel Tegra cpufreq driver to make it more easy to
> add new SoC support, in addition to that, adding probe function in the
> driver to let probe defer can be used to control init sequence when we
> are going to support DVFS.
>
> Changes since v2:
>
> - Fix Kconfig.
> - Rebase on top of branch 'cpufreq-next' on git://git.linaro.org/people/vireshk/linux.git.

That's wrong base.. This branch is used only for Rafael to pull in
stuff and so it doesn't
get updated everyday..

You must rebase on Rafael's linux-next branch all the time.
