Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaIAXbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 19:31:20 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56539 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752655AbaIAXbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 19:31:19 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / Domains: Make generic_pm_domain.name const
Date: Tue, 02 Sep 2014 01:50:36 +0200
Message-ID: <7567220.FuQYiIRUM7@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409318001-27586-1-git-send-email-geert+renesas@glider.be>
References: <1409318001-27586-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 29, 2014 03:13:21 PM Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

I'm going to apply this one.  Does anything depend on it?

> ---
>  include/linux/pm_domain.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
> index 7c1d252b20c0..ebc4c76ffb73 100644
> --- a/include/linux/pm_domain.h
> +++ b/include/linux/pm_domain.h
> @@ -60,7 +60,7 @@ struct generic_pm_domain {
>  	struct mutex lock;
>  	struct dev_power_governor *gov;
>  	struct work_struct power_off_work;
> -	char *name;
> +	const char *name;
>  	unsigned int in_progress;	/* Number of devices being suspended now */
>  	atomic_t sd_count;	/* Number of subdomains with power "on" */
>  	enum gpd_status status;	/* Current state of the domain */
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
