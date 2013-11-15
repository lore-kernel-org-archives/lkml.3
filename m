Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab3KOEls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:41:48 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:47138 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab3KOElq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:41:46 -0500
Message-ID: <5285A600.1070807@linaro.org>
Date: Fri, 15 Nov 2013 10:11:36 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>, swarren@wwwdotorg.org,
        pawel.moll@arm.com, mark.rutland@arm.com, ian.campbell@citrix.com,
        rob.herring@calxeda.com, linux@roeck-us.net, rui.zhang@intel.com
CC: wni@nvidia.com, grant.likely@linaro.org, durgadoss.r@intel.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCHv5 05/20] cpufreq: cpufreq-cpu0: add dt node parsing for
 cooling device properties
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com> <1384285582-16933-6-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1384285582-16933-6-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 November 2013 01:16 AM, Eduardo Valentin wrote:
> This patch changes the cpufreq-cpu0 driver to consider if
> a cpu needs cooling (with cpufreq). In case the cooling is needed,
> the cpu0 device tree node needs to be properly configured
> with cooling device properties.
> 
> In case these properties are present,, the driver will
> load a cpufreq cooling device in the system. The cpufreq-cpu0
> driver is not interested in determining how the system should
> be using the cooling device. The driver is responsible
> only of loading the cooling device.
> 
> Describing how the cooling device will be used can be
> accomplished by setting up a thermal zone that references
> and is composed by the cpufreq cooling device.
> 
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: cpufreq@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt         |  7 +++++++
>  drivers/cpufreq/Kconfig                                  |  2 +-
>  drivers/cpufreq/cpufreq-cpu0.c                           | 16 ++++++++++++++++
>  3 files changed, 24 insertions(+), 1 deletion(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

