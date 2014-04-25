Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaDYVog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:44:36 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:41865 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaDYVob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:44:31 -0400
Message-ID: <535AD73C.5070809@gmail.com>
Date: Fri, 25 Apr 2014 23:44:28 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
CC: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, s.nawrocki@samsung.com,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH v2 07/10] ARM: EXYNOS: Remove "linux/bug.h" from pmu.c
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com> <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com> <1398429166-5539-8-git-send-email-pankaj.dubey@samsung.com>
In-Reply-To: <1398429166-5539-8-git-send-email-pankaj.dubey@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 25.04.2014 14:32, Pankaj Dubey wrote:
> From: Young-Gun Jang <yg1004.jang@samsung.com>
>
> This patch removes unnecessary header file inclusion from pmu.c.
>
> Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
> ---
>   arch/arm/mach-exynos/pmu.c |    1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
> index 05c7ce1..4c3453a 100644
> --- a/arch/arm/mach-exynos/pmu.c
> +++ b/arch/arm/mach-exynos/pmu.c
> @@ -11,7 +11,6 @@
>
>   #include <linux/io.h>
>   #include <linux/kernel.h>
> -#include <linux/bug.h>
>
>   #include <plat/cpu.h>
>
>

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
