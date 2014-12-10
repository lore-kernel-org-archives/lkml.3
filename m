Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbaLJVYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 16:24:25 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54077 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932426AbaLJVYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 16:24:24 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Anjana Sasindran <anjanasasindran123@gmail.com>
Cc: daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: cpuidle: Added a blank line after declarations
Date: Wed, 10 Dec 2014 22:45:59 +0100
Message-ID: <354575085.t1Bv5Pht3m@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418233044-12059-1-git-send-email-anjanasasindran123@gmail.com>
References: <1418233044-12059-1-git-send-email-anjanasasindran123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 10, 2014 11:07:24 PM Anjana Sasindran wrote:
> This patch fix the checkpatch.pl warning:
> 
> WARNING: Missing blank line after declarations

Please send a patch to checkpatch.pl maintainers to make it not complain in
this case instead.  Thanks!

> Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
> ---
>  drivers/cpuidle/driver.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index e431d11..7fa66f6 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -144,6 +144,7 @@ static inline void __cpuidle_unset_driver(struct cpuidle_driver *drv)
>  static void cpuidle_setup_broadcast_timer(void *arg)
>  {
>  	int cpu = smp_processor_id();
> +
>  	clockevents_notify((long)(arg), &cpu);
>  }
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
