Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaLSIVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:21:49 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33189 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaLSIVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:21:48 -0500
MIME-Version: 1.0
In-Reply-To: <201412191646.uhe36Ci6%fengguang.wu@intel.com>
References: <201412191646.uhe36Ci6%fengguang.wu@intel.com>
Date: Fri, 19 Dec 2014 13:51:47 +0530
Message-ID: <CAKohpo=2xJXWG0jGZP=o_FGhcdp0HAj_O7T_pM96g9RzDMkYDQ@mail.gmail.com>
Subject: Re: [vireshk:cpufreq/stats/cleanups 12/14] drivers/cpufreq/cpufreq_stats.c:19:1:
 sparse: symbol 'cpufreq_stats_lock' was not declared. Should it be static?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 December 2014 at 13:47, kbuild test robot <fengguang.wu@intel.com> wrote:
> tree:   https://git.linaro.org/people/vireshk/linux cpufreq/stats/cleanups
> head:   f6439741b76da59257758838e8b24472831e850c
> commit: 2194c3c381af6cbfe8ab4fda481e07a004446e30 [12/14] cpufreq: stats: replace spinlock with mutex
> reproduce:
>   # apt-get install sparse
>   git checkout 2194c3c381af6cbfe8ab4fda481e07a004446e30
>   make ARCH=x86_64 allmodconfig
>   make C=1 CF=-D__CHECK_ENDIAN__
>
>
> sparse warnings: (new ones prefixed by >>)
>
>>> drivers/cpufreq/cpufreq_stats.c:19:1: sparse: symbol 'cpufreq_stats_lock' was not declared. Should it be static?
>
> Please review and possibly fold the followup patch.

Thanks fixed.
