Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbbAZJUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:20:35 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56161 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbbAZJUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:20:31 -0500
Message-ID: <54C606D8.4080904@ti.com>
Date: Mon, 26 Jan 2015 11:20:24 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Semen Protsenko <semen.protsenko@globallogic.com>,
        Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: OMAP2+: gpmc: make gpmc_cs_get_name() static
References: <1422131320-1018-1-git-send-email-semen.protsenko@globallogic.com> <1422131320-1018-2-git-send-email-semen.protsenko@globallogic.com>
In-Reply-To: <1422131320-1018-2-git-send-email-semen.protsenko@globallogic.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/01/15 22:28, Semen Protsenko wrote:
> Fix sparse warning:
>   warning: symbol 'gpmc_cs_get_name' was not declared. Should it be static?
> 
> Signed-off-by: Semen Protsenko <semen.protsenko@globallogic.com>

Acked-by: Roger Quadros <rogerq@ti.com>

cheers,
-roger

> ---
>  drivers/memory/omap-gpmc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/memory/omap-gpmc.c b/drivers/memory/omap-gpmc.c
> index 10eb4ac..db77adb 100644
> --- a/drivers/memory/omap-gpmc.c
> +++ b/drivers/memory/omap-gpmc.c
> @@ -668,7 +668,7 @@ static void gpmc_cs_set_name(int cs, const char *name)
>  	gpmc->name = name;
>  }
>  
> -const char *gpmc_cs_get_name(int cs)
> +static const char *gpmc_cs_get_name(int cs)
>  {
>  	struct gpmc_cs_data *gpmc = &gpmc_cs[cs];
>  
> 

