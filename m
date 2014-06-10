Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaFJRTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:19:25 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:56476 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaFJRTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:19:24 -0400
Message-ID: <53973E19.1080107@gmail.com>
Date: Tue, 10 Jun 2014 10:19:21 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stratos Karafotis <stratosk@semaphore.gr>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: dirk.brandewie@gmail.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] cpufreq: intel_pstate: Make intel_pstate_kobject
 local
References: <53962096.1060202@semaphore.gr>
In-Reply-To: <53962096.1060202@semaphore.gr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 02:01 PM, Stratos Karafotis wrote:
> Since we never remove sysfs entry, we can make the intel_pstate_kobject
> local.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

>   drivers/cpufreq/intel_pstate.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index fa44f0f..9533fff 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -387,10 +387,10 @@ static struct attribute *intel_pstate_attributes[] = {
>   static struct attribute_group intel_pstate_attr_group = {
>   	.attrs = intel_pstate_attributes,
>   };
> -static struct kobject *intel_pstate_kobject;
>
>   static void intel_pstate_sysfs_expose_params(void)
>   {
> +	struct kobject *intel_pstate_kobject;
>   	int rc;
>
>   	intel_pstate_kobject = kobject_create_and_add("intel_pstate",
>

