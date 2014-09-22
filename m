Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaIVNpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:45:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62052 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753486AbaIVNpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:45:06 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Jiri Kosina <trivial@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] PM / Domains: Spelling s/domian/domain/
Date: Mon, 22 Sep 2014 16:04:52 +0200
Message-ID: <1514200.c92a0jFWZ0@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410897579-28240-1-git-send-email-geert+renesas@glider.be>
References: <1410897579-28240-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 16, 2014 09:59:39 PM Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Queued up for 3.18, thanks!

> ---
>  drivers/base/power/domain.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index cf4651a15a5753e5..e6a11ca3ce2634ab 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -1833,7 +1833,7 @@ int pm_genpd_name_detach_cpuidle(const char *name)
>  /* Default device callbacks for generic PM domains. */
>  
>  /**
> - * pm_genpd_default_save_state - Default "save device state" for PM domians.
> + * pm_genpd_default_save_state - Default "save device state" for PM domains.
>   * @dev: Device to handle.
>   */
>  static int pm_genpd_default_save_state(struct device *dev)
> @@ -1856,7 +1856,7 @@ static int pm_genpd_default_save_state(struct device *dev)
>  }
>  
>  /**
> - * pm_genpd_default_restore_state - Default PM domians "restore device state".
> + * pm_genpd_default_restore_state - Default PM domains "restore device state".
>   * @dev: Device to handle.
>   */
>  static int pm_genpd_default_restore_state(struct device *dev)
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
