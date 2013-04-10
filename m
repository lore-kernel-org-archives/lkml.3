Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936988Ab3DJKeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:34:11 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:49282 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036Ab3DJKeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:34:10 -0400
Message-ID: <51653FE7.6040902@huawei.com>
Date: Wed, 10 Apr 2013 18:33:11 +0800
From: Hanjun Guo <guohanjun@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] ACPI and PM patches for Euler stable from mainline
 v3.6
References: <1365589381-5624-1-git-send-email-guohanjun@huawei.com>
In-Reply-To: <1365589381-5624-1-git-send-email-guohanjun@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.124]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made a mistake in sending email, sorry for the bothering, please ignore it.

On 2013/4/10 18:22, Hanjun Guo wrote:
> Hi Zefan,
> 
> These four patches are bugfix for ACPI and power management from mainline 
> v3.6, comments are welcomed!
> 
> Thanks
> Hanjun Guo
> 
> 
> Colin Cross (1):
>   cpuidle: fix error handling in __cpuidle_register_device
> 
> Stephen Boyd (1):
>   cpufreq: Fix sysfs deadlock with concurrent hotplug/frequency switch
> 
> Thomas Renninger (2):
>   ACPI: Untangle a return statement for better readability
>   ACPI: Only count valid srat memory structures
> 
>  arch/ia64/kernel/acpi.c   |    5 +++--
>  arch/x86/mm/srat.c        |   16 +++++++++-------
>  drivers/acpi/numa.c       |   12 ++++++++----
>  drivers/cpufreq/cpufreq.c |   35 +++++++++++++++++++++++++++--------
>  drivers/cpuidle/cpuidle.c |   13 +++++++++----
>  include/linux/acpi.h      |    2 +-
>  6 files changed, 57 insertions(+), 26 deletions(-)
> 
> 
> _______________________________________________
> Kernel.openeuler mailing list
> Kernel.openeuler@huawei.com
> http://rnd-openeuler.huawei.com/mailman/listinfo/kernel.openeuler
> 
> 


