Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbaGSUKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 16:10:24 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61283 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755773AbaGSUKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 16:10:22 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        dcb314@hotmail.com, rafael.j.wysocki@intel.com, trenn@suse.de,
        linux@dominikbrodowski.net, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/5] tools/power/cpupower/utils/helpers/sysfs.c: drop negativity check on unsigned value
Date: Sat, 19 Jul 2014 22:28:41 +0200
Message-ID: <3471157.kIgI5mxtgb@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405797244-5182-1-git-send-email-andrey.krieger.utkin@gmail.com>
References: <1405697445-23620-1-git-send-email-andrey.krieger.utkin@gmail.com> <1405797244-5182-1-git-send-email-andrey.krieger.utkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 19, 2014 10:14:04 PM Andrey Utkin wrote:
> Resubmitting to send also to linux-pm@vger.kernel.org as requested by
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> ---8<---
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80621
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Queued up for 3.17, thanks!

> ---
>  tools/power/cpupower/utils/helpers/sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/power/cpupower/utils/helpers/sysfs.c b/tools/power/cpupower/utils/helpers/sysfs.c
> index 851c7a1..09afe5d 100644
> --- a/tools/power/cpupower/utils/helpers/sysfs.c
> +++ b/tools/power/cpupower/utils/helpers/sysfs.c
> @@ -81,7 +81,7 @@ int sysfs_is_cpu_online(unsigned int cpu)
>  	close(fd);
>  
>  	value = strtoull(linebuf, &endp, 0);
> -	if (value > 1 || value < 0)
> +	if (value > 1)
>  		return -EINVAL;
>  
>  	return value;
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
