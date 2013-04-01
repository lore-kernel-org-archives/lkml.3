Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab3DAU6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:58:10 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49606 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757584Ab3DAU6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:58:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] CPUFreq Updates & Fixes for 3.10
Date: Mon, 01 Apr 2013 23:05:43 +0200
Message-ID: <1893788.IlN605kbG3@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 01, 2013 06:27:40 PM Viresh Kumar wrote:
> Hi Rafael,
> 
> These are fixes and updates that are sent and reviewed as separate patchsets
> earlier. They are all now combined as part of a single patchset for you to apply
> in your linux-next branch.
> 
> All have got reviews earlier and got fixups mailed and applied.
> 
> The remaining patches: "Move Cpufreq drivers to drivers/cpufreq" are awaiting
> few more Acks before I send them to you.
> 
> I wanted to have another patch as part of this patchset, but I am awaiting Ack
> for it:
> tools: cpufreq: Fix cpufreq-info print messages for affected[related]_cpus
> 
> That can be applied separately once it receives an Ack.
> 
> Thanks
> Viresh
> 
> Viresh Kumar (9):
>   cpufreq: cpu0: Fix mistake in Documentation example
>   cpufreq: Documentation: Fix cpufreq_frequency_table name
>   cpufreq: cpufreq-cpu0: No need to check cpu number in init()
>   cpufreq: cpufreq-cpu0: Call CPUFREQ_POSTCHANGE notifier for failure
>     cases too
>   cpufreq: Notify all policy->cpus in cpufreq_notify_transition()
>   cpufreq: Don't check if cpu is online/offline for cpufreq callbacks
>   cpufreq: drivers: don't check range of target freq in .target()
>   cpufreq: drivers: Remove unnecessary assignments of policy-> members
>   cpufreq: ARM big LITTLE: Add generic cpufreq driver and its DT glue

Thanks!

The [5/9] seems to be missing.  Care to send?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
