Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521Ab3GaOW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:22:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57462 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760494Ab3GaOW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:22:57 -0400
Message-ID: <51F91DBB.6010400@ti.com>
Date: Wed, 31 Jul 2013 10:22:51 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 08/15] cpufreq: omap: initialize .owner field with THIS_MODULE
References: <cover.1375279948.git.viresh.kumar@linaro.org> <2274a4c250c83058b5b2df75f33e47fe1422036a.1375279948.git.viresh.kumar@linaro.org>
In-Reply-To: <2274a4c250c83058b5b2df75f33e47fe1422036a.1375279948.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 July 2013 10:19 AM, Viresh Kumar wrote:
> CPUFreq core does following at multiple places:
> module_{get|put}(cpufreq_driver->owner)).
> 
> This is done to make sure module doesn't get unloaded if it is currently in use.
> This will work only if the .owner field of cpufreq driver is initialized with a
> valid pointer.
> 
> This field wasn't initialized for this driver, lets initialize it with
> THIS_MODULE.
> 
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
Looks fine.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

