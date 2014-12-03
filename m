Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbaLBXrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:47:09 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61191 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932722AbaLBXrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:47:07 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: add MAINTAINERS entry for ARM Exynos cpuidle driver
Date: Wed, 03 Dec 2014 01:08:28 +0100
Message-ID: <1466322.AKaPtIKjPo@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1616359.KRpRrFqxfV@amdc1032>
References: <1616359.KRpRrFqxfV@amdc1032>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 02, 2014 04:41:35 PM Bartlomiej Zolnierkiewicz wrote:
> Since there has been quite a lot of development going on for
> ARM Exynos cpuidle driver recently I would like to add separate
> MAINTAINERS entry for it and add myself as the primary maintainer.
> 
> The merging process would remain (almost) unchanged with patches
> going (with my Ack) through Daniel's or Kukjin's tree.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

Daniel, do you want me to apply this, or are you going to do that?

> ---
>  MAINTAINERS |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> Index: b/MAINTAINERS
> ===================================================================
> --- a/MAINTAINERS	2014-11-27 18:02:51.988225868 +0100
> +++ b/MAINTAINERS	2014-12-02 15:56:52.792997513 +0100
> @@ -2701,6 +2701,16 @@ T:	git git://git.kernel.org/pub/scm/linu
>  S:	Maintained
>  F:	drivers/cpuidle/cpuidle-big_little.c
>  
> +CPUIDLE DRIVER - ARM EXYNOS
> +M:	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> +M:	Daniel Lezcano <daniel.lezcano@linaro.org>
> +M:	Kukjin Kim <kgene@kernel.org>
> +L:	linux-pm@vger.kernel.org
> +L:	linux-samsung-soc@vger.kernel.org
> +S:	Supported
> +F:	drivers/cpuidle/cpuidle-exynos.c
> +F:	arch/arm/mach-exynos/pm.c
> +
>  CPUIDLE DRIVERS
>  M:	Rafael J. Wysocki <rjw@rjwysocki.net>
>  M:	Daniel Lezcano <daniel.lezcano@linaro.org>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
