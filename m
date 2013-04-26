Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab3DZQzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:55:15 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58781 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3DZQzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:55:13 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        arnd.bergmann@linaro.org, olof@lixom.net
Subject: Re: [PATCH V2] cpufreq: MAINTAINERS: Add co-maintainer
References: <d62f23f626eaf334236cb9694c83ee4619460b76.1366980696.git.viresh.kumar@linaro.org>
Date: Fri, 26 Apr 2013 09:55:08 -0700
In-Reply-To: <d62f23f626eaf334236cb9694c83ee4619460b76.1366980696.git.viresh.kumar@linaro.org>
	(Viresh Kumar's message of "Fri, 26 Apr 2013 18:23:16 +0530")
Message-ID: <87k3npz0yb.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh Kumar <viresh.kumar@linaro.org> writes:

> With prior discussions (Over private emails) with current Maintainer of cpufreq
> framework (Rafael), I am adding myself as a co-maintainer of cpufreq framework.
>
> This would mostly be for cpufreq core and ARM drivers but not restricted to
> them.
>
> This also adds path of the git tree where cpufreq patches are pulled in.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

As long as you continue to make an effort to ensure that the
platform-specific drivers have proper acks from platform-specific folks.
For ARM, this means not the arm-soc maintainers but the ARM subarch
maintianers.

Acked-by: Kevin Hilman <khilman@linaro.org>

> ---
> V1->V2:
> - Added path of git tree too.
> - Cc'd ARM SoC Maintainers.
>
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 68d376e..cbed63c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2211,9 +2211,11 @@ F:	drivers/net/ethernet/ti/cpmac.c
>  
>  CPU FREQUENCY DRIVERS
>  M:	Rafael J. Wysocki <rjw@sisk.pl>
> +M:	Viresh Kumar <viresh.kumar@linaro.org>
>  L:	cpufreq@vger.kernel.org
>  L:	linux-pm@vger.kernel.org
>  S:	Maintained
> +T:	git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
>  F:	drivers/cpufreq/
>  F:	include/linux/cpufreq.h
