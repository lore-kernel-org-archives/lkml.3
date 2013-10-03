Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3JCH31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 03:29:27 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:43904 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab3JCH3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 03:29:25 -0400
Message-ID: <524D1BD6.4040608@linux.vnet.ibm.com>
Date: Thu, 03 Oct 2013 12:55:10 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 03/11] cpufreq: remove invalid comment from __cpufreq_remove_dev()
References: <cover.1380703248.git.viresh.kumar@linaro.org> <0d25692a141042a3d4d6fab310029e96fbe57822.1380703248.git.viresh.kumar@linaro.org>
In-Reply-To: <0d25692a141042a3d4d6fab310029e96fbe57822.1380703248.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100307-2000-0000-0000-00000DF5D816
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 02:13 PM, Viresh Kumar wrote:
> Some section of kerneldoc comment for __cpufreq_remove_dev() is invalid now.
> Remove it.
> 
> Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  drivers/cpufreq/cpufreq.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index ae866b1..d80cbe6 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1260,8 +1260,6 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>   * __cpufreq_remove_dev - remove a CPU device
>   *
>   * Removes the cpufreq interface for a CPU device.
> - * Caller should already have policy_rwsem in write mode for this CPU.
> - * This routine frees the rwsem before returning.
>   */
>  static inline int __cpufreq_remove_dev(struct device *dev,
>  				       struct subsys_interface *sif,
> 

