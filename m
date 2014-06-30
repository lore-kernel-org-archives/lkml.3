Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbaF3Cuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 22:50:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:38026 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbaF3Cuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 22:50:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,573,1400050800"; 
   d="scan'208";a="565795270"
Message-ID: <1404096633.2289.7.camel@rzhang1-toshiba>
Subject: Re: [PATCH TRIVIAL] thermal: cpu_cooling: fix typo highjack ->
 hijack
From: Zhang Rui <rui.zhang@intel.com>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org,
        Eduardo Valentin <eduardo.valentin@ti.com>
Date: Mon, 30 Jun 2014 10:50:33 +0800
In-Reply-To: <1403716277-1351-1-git-send-email-javi.merino@arm.com>
References: <1403716277-1351-1-git-send-email-javi.merino@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 18:11 +0100, Javi Merino wrote:
> Cc: Eduardo Valentin <eduardo.valentin@ti.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Signed-off-by: Javi Merino <javi.merino@arm.com>

applied, thanks!

-rui
> ---
>  drivers/thermal/cpu_cooling.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 84a75f89bf74..1ab0018271c5 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -305,7 +305,7 @@ static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
>   * @event: value showing cpufreq event for which this function invoked.
>   * @data: callback-specific data
>   *
> - * Callback to highjack the notification on cpufreq policy transition.
> + * Callback to hijack the notification on cpufreq policy transition.
>   * Every time there is a change in policy, we will intercept and
>   * update the cpufreq policy with thermal constraints.
>   *


