Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab3ILIUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:20:11 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:38522 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484Ab3ILIUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:20:09 -0400
Message-ID: <52317849.90101@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 13:46:09 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, swarren@wwwdotorg.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] cpufreq: Remove extra blank line
References: <cover.1378963070.git.viresh.kumar@linaro.org> <22f0d94203b9e3d29f123c0e80df4b012e01dbb5.1378963070.git.viresh.kumar@linaro.org>
In-Reply-To: <22f0d94203b9e3d29f123c0e80df4b012e01dbb5.1378963070.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091208-9574-0000-0000-00000998C3D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 10:55 AM, Viresh Kumar wrote:
> We don't need a blank line just at start of a block, lets remove it.
> 

Well, I felt having that line avoids clutter, especially since the code
around it was already a bit hard to read..

Anyway, I don't have any strong opinions either way. So no objections
from my side. (But you might have to rebase this patch on top of Rafael's
tree, due to the recent changes he pushed in to this code).

Regards,
Srivatsa S. Bhat

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 5a64f66..28477eb 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1185,7 +1185,6 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>  	if (cpu != policy->cpu && !frozen) {
>  		sysfs_remove_link(&dev->kobj, "cpufreq");
>  	} else if (cpus > 1) {
> -
>  		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu, frozen);
>  		if (new_cpu >= 0) {
>  			WARN_ON(lock_policy_rwsem_write(cpu));
> 

