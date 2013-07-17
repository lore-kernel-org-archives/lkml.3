Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3GQJze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:55:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab3GQJzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:55:33 -0400
Subject: Re: [PATCH 3/6] kconfig/[mn]conf: shorten title in search-box
From: Jean Delvare <jdelvare@suse.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
In-Reply-To: <f6eb6e46f766f4e2eb64d2d467ef7efff084c47c.1374006854.git.yann.morin.1998@free.fr>
References: <cover.1374006854.git.yann.morin.1998@free.fr>
	 <f6eb6e46f766f4e2eb64d2d467ef7efff084c47c.1374006854.git.yann.morin.1998@free.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Wed, 17 Jul 2013 11:55:12 +0200
Message-ID: <1374054912.4495.0.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tuesday 16 July 2013 à 22:39 +0200, Yann E. MORIN a écrit :
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> No need to repeat the 'CONFIG_' string in the title,
> once is explicit enough.
> 
> Reported-by: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> Cc: Jean Delvare <jdelvare@suse.de>
> ---
>  scripts/kconfig/mconf.c | 4 ++--
>  scripts/kconfig/nconf.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> index 18d3dc9..b20e851 100644
> --- a/scripts/kconfig/mconf.c
> +++ b/scripts/kconfig/mconf.c
> @@ -401,8 +401,8 @@ static void search_conf(void)
>  	struct subtitle_part stpart;
>  
>  	title = str_new();
> -	str_printf( &title, _("Enter %s (sub)string or regexp to search for "
> -			      "(with or without \"%s\")"), CONFIG_, CONFIG_);
> +	str_printf( &title, _("Enter (sub)string or regexp to search for "
> +			      "(with or without \"%s\")"), CONFIG_);
>  
>  again:
>  	dialog_clear();
> diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
> index 7975d8d..4fbecd2 100644
> --- a/scripts/kconfig/nconf.c
> +++ b/scripts/kconfig/nconf.c
> @@ -695,8 +695,8 @@ static void search_conf(void)
>  	int dres;
>  
>  	title = str_new();
> -	str_printf( &title, _("Enter %s (sub)string or regexp to search for "
> -			      "(with or without \"%s\")"), CONFIG_, CONFIG_);
> +	str_printf( &title, _("Enter (sub)string or regexp to search for "
> +			      "(with or without \"%s\")"), CONFIG_);
>  
>  again:
>  	dres = dialog_inputbox(main_window,

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
Suse L3

