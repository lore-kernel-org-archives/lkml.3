Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab3A2LpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:45:18 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:58459 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab3A2LpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:45:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: inderpal.singh@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Subject: Re: [PATCH 1/2] cpufreq: Set policy->related_cpus to atleast policy->cpus
Date: Tue, 29 Jan 2013 12:51:23 +0100
Message-ID: <2215618.GPIWS1OcnB@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <d6827976a56d429848ab8ababa2779a21c68d65f.1359434113.git.viresh.kumar@linaro.org>
References: <d6827976a56d429848ab8ababa2779a21c68d65f.1359434113.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 29, 2013 10:09:59 AM Viresh Kumar wrote:
> With the addition of following patch, related_cpus is required to be set by
> cpufreq platform drivers:
> 
> commit c1070fd743533efb54e98142252283583f379190
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Mon Jan 14 13:23:04 2013 +0000
> 
>     cpufreq: Simplify cpufreq_add_dev()
> 

I've dropped this one in the meantime.

Can you please fold the $subject patch into "cpufreq: Simplify cpufreq_add_dev()"
and post the result instead?  That surely will be less confusing?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
