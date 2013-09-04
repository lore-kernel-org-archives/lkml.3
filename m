Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934727Ab3IDJnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:43:23 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:55223 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934563Ab3IDJnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:43:21 -0400
Date: Wed, 4 Sep 2013 10:43:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, anton@enomsg.org
Subject: Re: [PATCH 4/4] pm2301-charger: Staticize
 pm2xxx_charger_die_therm_mngt
Message-ID: <20130904094316.GF20150@lee--X1>
References: <1378120226-24805-1-git-send-email-sachin.kamat@linaro.org>
 <1378120226-24805-4-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378120226-24805-4-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Sep 2013, Sachin Kamat wrote:

> pm2xxx_charger_die_therm_mngt is used only in this file.
> Make it static.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/power/pm2301_charger.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
> index ab87d1a..b9e1ef7 100644
> --- a/drivers/power/pm2301_charger.c
> +++ b/drivers/power/pm2301_charger.c
> @@ -205,7 +205,7 @@ static int pm2xxx_charger_batt_therm_mngt(struct pm2xxx_charger *pm2, int val)
>  }
>  
>  
> -int pm2xxx_charger_die_therm_mngt(struct pm2xxx_charger *pm2, int val)
> +static int pm2xxx_charger_die_therm_mngt(struct pm2xxx_charger *pm2, int val)
>  {
>  	queue_work(pm2->charger_wq, &pm2->check_main_thermal_prot_work);
>  

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
