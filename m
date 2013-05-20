Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab3ETGy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:54:57 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:23454 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3ETGy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:54:56 -0400
Date: Mon, 20 May 2013 08:54:40 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] MAINTAINERS: Add myself as maintainer for
  LM95234 and TMP401 drivers
Message-ID: <20130520085440.4c99e9d7@endymion.delvare>
In-Reply-To: <1369021715-31502-1-git-send-email-linux@roeck-us.net>
References: <1369021715-31502-1-git-send-email-linux@roeck-us.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 May 2013 20:48:35 -0700, Guenter Roeck wrote:
> I wrote the LM95234 driver and extended the TMP401 driver substantially,
> and I have hardware to test both, so it makes sense to explicitly
> maintain them.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  MAINTAINERS |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3d7782b..f0f3d20 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4976,6 +4976,13 @@ S:	Maintained
>  F:	Documentation/hwmon/lm90
>  F:	drivers/hwmon/lm90.c
>  
> +LM95234 HARDWARE MONITOR DRIVER
> +M:	Guenter Roeck <linux@roeck-us.net>
> +L:	lm-sensors@lm-sensors.org
> +S:	Maintained
> +F:	Documentation/hwmon/lm95234
> +F:	drivers/hwmon/lm95234.c
> +
>  LME2510 MEDIA DRIVER
>  M:	Malcolm Priestley <tvboxspy@gmail.com>
>  L:	linux-media@vger.kernel.org
> @@ -8182,6 +8189,13 @@ F:	drivers/mmc/host/sh_mobile_sdhi.c
>  F:	include/linux/mmc/tmio.h
>  F:	include/linux/mmc/sh_mobile_sdhi.h
>  
> +TMP401 HARDWARE MONITOR DRIVER
> +M:	Guenter Roeck <linux@roeck-us.net>
> +L:	lm-sensors@lm-sensors.org
> +S:	Maintained
> +F:	Documentation/hwmon/tmp401
> +F:	drivers/hwmon/tmp401.c
> +
>  TMPFS (SHMEM FILESYSTEM)
>  M:	Hugh Dickins <hughd@google.com>
>  L:	linux-mm@kvack.org

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
