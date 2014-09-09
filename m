Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaIIFDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:03:30 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:45425 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaIIFD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:03:29 -0400
MIME-Version: 1.0
In-Reply-To: <1410221424-20590-1-git-send-email-anupc@chromium.org>
References: <1410221424-20590-1-git-send-email-anupc@chromium.org>
Date: Tue, 9 Sep 2014 10:33:23 +0530
Message-ID: <CAKohponb199_zt11M2J39yHn45MjFMSrT+hPBp7rbqiHu4vKpQ@mail.gmail.com>
Subject: Re: [PATCH] intel_pstate: track and export frequency residency stats
 via sysfs.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Anup Chenthamarakshan <anupc@chromium.org>
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Sameer Nanda <snanda@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 September 2014 05:40, Anup Chenthamarakshan <anupc@chromium.org> wrote:
> Exported stats appear in
> <sysfs>/devices/system/cpu/intel_pstate/time_in_state as follows:
>
> ## CPU 0
> 400000 3647
> 500000 24342
> 600000 144150
> 700000 202469
> ## CPU 1
> 400000 4813
> 500000 22628
> 600000 149564
> 700000 211885
> 800000 173890
>
> Signed-off-by: Anup Chenthamarakshan <anupc@chromium.org>
> ---
>  drivers/cpufreq/intel_pstate.c | 77 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 74 insertions(+), 3 deletions(-)

Why don't we reuse cpufreq_stats.c for all this?
