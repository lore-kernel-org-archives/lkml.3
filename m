Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbaGIOpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:45:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40892 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782AbaGIOpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:45:09 -0400
Message-ID: <53BD5564.2060704@ti.com>
Date: Wed, 9 Jul 2014 10:44:52 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, <rjw@rjwysocki.net>,
        <shawn.guo@linaro.org>
CC: <nm@ti.com>, <linaro-kernel@lists.linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <t.figa@samsung.com>,
        <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <thomas.ab@samsung.com>, <arvind.chauhan@arm.com>,
        <spk.linux@gmail.com>
Subject: Re: [PATCH 07/14] cpufreq: cpu0: OPPs can be populated at runtime
References: <cover.1404231535.git.viresh.kumar@linaro.org> <1ba7771e910084cd0820c19ca5994fe1b3d6451d.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <1ba7771e910084cd0820c19ca5994fe1b3d6451d.1404231535.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2014 12:32 PM, Viresh Kumar wrote:
> OPPs can be populated statically, via DT, or added at run time with
> dev_pm_opp_add().
> 
> While this driver handles the first case correctly, it would fail to populate
> OPPs added at runtime. Because call to of_init_opp_table() would fail as there
> are no OPPs in DT and probe will return early.
> 
> To fix this, remove error checking and call dev_pm_opp_init_cpufreq_table()
> unconditionally.
> 
> Suggested-by: Stephen Boyd <sboyd@codeaurora.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
Assuming you are updating bidnings as suggested by Stephen,
patch looks good to me.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>


