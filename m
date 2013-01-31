Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3AaRb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:31:27 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:58072 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab3AaR37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:29:59 -0500
MIME-Version: 1.0
In-Reply-To: <09a94ff044ff6a6f7a5d953c3b1f3102c1dc50cf.1359653181.git.viresh.kumar@linaro.org>
References: <09a94ff044ff6a6f7a5d953c3b1f3102c1dc50cf.1359653181.git.viresh.kumar@linaro.org>
Date: Thu, 31 Jan 2013 22:59:58 +0530
Message-ID: <CAKohpomqerpAuXwbObKoKg44zO2QwL_ckSV5fEkTBtpzdpsDBg@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: governors: Get rid of dbs_data->enable field
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, fabio.baltieri@linaro.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 January 2013 22:58, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> CPUFREQ_GOV_START/STOP are called only once for all policy->cpus and hence we
> don't need to adapt cpufreq_governor_dbs() routine for multiple calls.
>
> So, this patch removes dbs_data->enable field entirely. And rearrange code a
> bit.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Hi Fabio,
>
> I have fixed all the pending issues, but haven't checked these patches. Can you
> please add your tested-by (obviously after testing them) ?

BTW, these are rebased over your patches and git log shows:

af8a2e1 cpufreq: governors: Remove code redundancy between governors
09a94ff cpufreq: governors: Get rid of dbs_data->enable field
faa8107 cpufreq: governors: implement generic policy_is_shared
88fe0a9 cpufreq: governors: clean timer init and exit code
13c18e8 cpufreq: governors: fix misuse of cdbs.cpu
