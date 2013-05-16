Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab3EPIhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:37:55 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50715 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab3EPIhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:37:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH 0/3] CPUFreq Fixes for 3.10-rc2
Date: Thu, 16 May 2013 10:46:26 +0200
Message-ID: <6691801.RqjZrI7EgH@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <cover.1368679353.git.viresh.kumar@linaro.org>
References: <cover.1368679353.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 16, 2013 10:39:55 AM Viresh Kumar wrote:
> Hi Rafael,

Hi,

> Here are few more fixes for 3.10-rc2.

I'm actually going to sent the for-rc2 request today, so these are for -rc3.

> Viresh Kumar (3):
>   cpufreq: Add EXPORT_SYMBOL_GPL for have_governor_per_policy
>   cpufreq: governors: Move get_governor_parent_kobj() to cpufreq.c
>   cpufreq: Drop rwsem lock around CPUFREQ_GOV_POLICY_EXIT

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
