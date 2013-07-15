Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab3GOPHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:07:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41499 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab3GOPHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:07:18 -0400
Message-ID: <51E40FF8.4020504@infradead.org>
Date: Mon, 15 Jul 2013 08:06:32 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] treewide: Fix typo in printk
References: <1373896210-21316-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1373896210-21316-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/13 06:50, Masanari Iida wrote:
> Correct spelling typo in printk
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/crypto/ux500/hash/hash_core.c               | 2 +-
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 4 ++--
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c      | 2 +-
>  drivers/net/wireless/cw1200/wsm.c                   | 2 +-
>  drivers/net/wireless/iwlwifi/mvm/time-event.c       | 2 +-
>  drivers/net/wireless/rtlwifi/rtl8188ee/fw.c         | 4 ++--
>  drivers/net/wireless/rtlwifi/rtl8723ae/fw.c         | 4 ++--
>  drivers/power/88pm860x_charger.c                    | 4 ++--
>  drivers/power/pm2301_charger.c                      | 2 +-
>  drivers/scsi/lpfc/lpfc_attr.c                       | 8 ++++----
>  drivers/scsi/qla2xxx/qla_mr.c                       | 2 +-
>  11 files changed, 18 insertions(+), 18 deletions(-)
> 

I would make the following 2 say "occurred" instead of "occur".
Otherwise looks good to me.
Thanks.

> diff --git a/drivers/power/88pm860x_charger.c b/drivers/power/88pm860x_charger.c
> index ffff66b..2c843ca 100644
> --- a/drivers/power/88pm860x_charger.c
> +++ b/drivers/power/88pm860x_charger.c
> @@ -554,7 +554,7 @@ static irqreturn_t pm860x_vchg_handler(int irq, void *data)
>  					OVTEMP_AUTORECOVER,
>  					OVTEMP_AUTORECOVER);
>  			dev_dbg(info->dev,
> -				"%s, pm8606 over-temp occure\n", __func__);
> +				"%s, pm8606 over-temp occur\n", __func__);
>  		}
>  	}
>  
> @@ -562,7 +562,7 @@ static irqreturn_t pm860x_vchg_handler(int irq, void *data)
>  		set_vchg_threshold(info, VCHG_OVP_LOW, 0);
>  		info->allowed = 0;
>  		dev_dbg(info->dev,
> -			"%s,pm8607 over-vchg occure,vchg = %dmv\n",
> +			"%s,pm8607 over-vchg occur,vchg = %dmv\n",
>  			__func__, vchg);
>  	} else if (vchg < VCHG_OVP_LOW) {
>  		set_vchg_threshold(info, VCHG_NORMAL_LOW,

-- 
~Randy
