Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaGIOpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:45:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44889 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169AbaGIOpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:45:44 -0400
Message-ID: <53BD5587.6090005@ti.com>
Date: Wed, 9 Jul 2014 10:45:27 -0400
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
Subject: Re: [PATCH 08/14] cpufreq: cpu0: use dev_{err|warn|dbg} instead of
 pr_{err|warn|debug}
References: <cover.1404231535.git.viresh.kumar@linaro.org> <3d66efb77d0f191e142b9fedda4efa3c31c098e9.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <3d66efb77d0f191e142b9fedda4efa3c31c098e9.1404231535.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2014 12:32 PM, Viresh Kumar wrote:
> We already have cpu_dev and is used at multiple places for printing errors using
> dev_*(). But some prints are still using pr_*(). Lets make it consistent and
> replace those pr_*() macros with dev_*() macros.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq-cpu0.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
> 
Looks good to me.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

