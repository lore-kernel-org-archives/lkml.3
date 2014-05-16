Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbaEPI67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:58:59 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46404 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567AbaEPI65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:58:57 -0400
Message-ID: <5375D35A.6030806@linaro.org>
Date: Fri, 16 May 2014 10:59:06 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: Tomasz Figa <t.figa@samsung.com>, Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 4/7] ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros
 by static inlines
References: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com> <1399287439-31376-5-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1399287439-31376-5-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 12:57 PM, Bartlomiej Zolnierkiewicz wrote:
> Replace EXYNOS_BOOT_VECTOR_ADDR and EXYNOS_BOOT_VECTOR_FLAG macros
> by exynos_boot_vector_addr() and exynos_boot_vector_flag() static
> inlines.
>
> This patch shouldn't cause any functionality changes.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

