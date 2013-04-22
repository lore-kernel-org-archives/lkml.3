Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3DVCQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 22:16:28 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:55252 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab3DVCQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 22:16:27 -0400
MIME-Version: 1.0
In-Reply-To: <1366218743-20841-2-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
	<1366218743-20841-2-git-send-email-eduardo.valentin@ti.com>
Date: Mon, 22 Apr 2013 07:46:26 +0530
X-Google-Sender-Auth: 4UW769hLNRvP-tbZxQeZbnup4zQ
Message-ID: <CADGdYn5qbXy9AOusj+=m3-RAZK_NcUCm-9T2=smu4yZpr1sN2g@mail.gmail.com>
Subject: Re: [PATCH 01/30] thermal: cpu_cooling: remove unused headers
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 17, 2013 at 10:41 PM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> As this code is not a module nor a platform device driver,
> this patch removes some unused header files.
>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

Reviewed-by: Amit Daniel Kachhap<amit.daniel@samsung.com>

Thanks,
Amit Daniel
> ---
>  drivers/thermal/cpu_cooling.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 5f5c780..778c43d 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -20,10 +20,7 @@
>   *
>   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   */
> -#include <linux/kernel.h>
> -#include <linux/module.h>
>  #include <linux/thermal.h>
> -#include <linux/platform_device.h>
>  #include <linux/cpufreq.h>
>  #include <linux/err.h>
>  #include <linux/slab.h>
> --
> 1.8.2.1.342.gfa7285d
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
