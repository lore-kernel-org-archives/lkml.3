Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3DVCSE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 22:18:04 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:37301 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab3DVCSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 22:18:02 -0400
MIME-Version: 1.0
In-Reply-To: <1366218743-20841-4-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
	<1366218743-20841-4-git-send-email-eduardo.valentin@ti.com>
Date: Mon, 22 Apr 2013 07:48:01 +0530
Message-ID: <CADGdYn6BmqEw37NMUU9XyE7x+oi=k0c6EJHhVjtDbUvF66upjA@mail.gmail.com>
Subject: Re: [PATCH 03/30] thermal: cpu_cooling: fix kernel_doc for cpufreq_cooling_device
From: amit kachhap <amit.kachhap@gmail.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 10:41 PM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> Simple fixes for making kernel_doc happy about
> struct cpufreq_cooling_device. Includes also a minor
> spelling fix.
>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

Reviewed-by: Amit Daniel Kachhap<amit.daniel@samsung.com>

Thanks,
Amit Daniel
> ---
>  drivers/thermal/cpu_cooling.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index d0d6a0c..7c0c05b 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -28,11 +28,11 @@
>  #include <linux/cpu_cooling.h>
>
>  /**
> - * struct cpufreq_cooling_device
> + * struct cpufreq_cooling_device - data for cooling device with cpufreq
>   * @id: unique integer value corresponding to each cpufreq_cooling_device
>   *     registered.
> - * @cool_dev: thermal_cooling_device pointer to keep track of the the
> - *     egistered cooling device.
> + * @cool_dev: thermal_cooling_device pointer to keep track of the
> + *     registered cooling device.
>   * @cpufreq_state: integer value representing the current state of cpufreq
>   *     cooling devices.
>   * @cpufreq_val: integer value representing the absolute value of the clipped
> --
> 1.8.2.1.342.gfa7285d
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
