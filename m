Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab3CLL0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:26:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37018 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab3CLL0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:26:16 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-6c-513f10d45bc9
Message-id: <513F10D9.9060402@samsung.com>
Date: Tue, 12 Mar 2013 20:26:17 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] mmc: dw_mmc: setpower on MMC_POWER_{UP,OFF}
References: <1363085012-9220-1-git-send-email-james.hogan@imgtec.com>
In-reply-to: <1363085012-9220-1-git-send-email-james.hogan@imgtec.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zPd0rAvaBBrc2KVtsf72RzeLdvBfM
	Fjd+tbFaXN41h83iyP9+RosP9y8yO7B59Ow8w+hx6MpaRo++LasYPT5vkgtgieKySUnNySxL
	LdK3S+DK2HTjJltBg0TFzatHmRoYlwh3MXJySAiYSBzf1cMOYYtJXLi3nq2LkYtDSGAZo8S0
	5uWsMEUXV91ihkhMZ5RoWbSRFcJ5ySjxfe1/FpAqXgEtiRl77zCB2CwCqhK3Vq8F62YT0JHY
	/u04WFxUIExi5fQrUPWCEj8m3wOzRQQ0JNZc6gWrYRZYxSixozsHxBYWcJBYvuo/I4gtJOAq
	cf7RAWYQm1PATeLspftQ9ToS+1unsUHY8hKb17wFu1RCYB+7RPv988wQBwlIfJt8CGgZB1BC
	VmITxBwJAUmJgytusExgFJuF5KRZSMbOQjJ2ASPzKkbR1ILkguKk9CJTveLE3OLSvHS95Pzc
	TYyQKJu4g/H+AetDjMlAKycyS4km5wOjNK8k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTE
	ktTs1NSC1KL4otKc1OJDjEwcnFINjCwz25VqDs+/XsaQspZ9k/SJ5umTy6WU1K7zRawKrt14
	aPu3hqid8vqZHaKTTpxs8Dj4/ue2Vx9vfQk5Pb9t8pGbvgeyr7/znyhw9AYP0+4VL4+/FFD3
	rZ8WLFpwY6b41QVboxpLvr72/vO+PLzsNhdD64SXZ1fMPLHlsfJu5qUvZkVPfjX3+YEdSizF
	GYmGWsxFxYkAL58dVMgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQd0rAvaBBrMXyVpsf72RzeLdvBfM
	Fjd+tbFaXN41h83iyP9+RosP9y8yO7B59Ow8w+hx6MpaRo++LasYPT5vkgtgiWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNh04yZbQYNExc2rR5kaGJcIdzFyckgImEhc
	XHWLGcIWk7hwbz1bFyMXh5DAdEaJlkUbWSGcl4wS39f+ZwGp4hXQkpix9w4TiM0ioCpxa/Va
	VhCbTUBHYvu342BxUYEwiZXTr0DVC0r8mHwPzBYR0JBYc6kXrIZZYBWjxI7uHBBbWMBBYvmq
	/4wgtpCAq8T5RwfALuIUcJM4e+k+VL2OxP7WaWwQtrzE5jVvmScwCsxCsmIWkrJZSMoWMDKv
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO4WdSOxhXNlgcYhTgYFTi4VX8ZhsoxJpYVlyZ
	e4hRgoNZSYQ3Y7NdoBBvSmJlVWpRfnxRaU5q8SHGZGAITGSWEk3OB6aXvJJ4Q2MTMyNLIzNj
	E3NjY9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpg5L60Su9+yOzmjsRI8YNyi+bYPr1Q
	+1tWRrBeibPwyle/3EDLDbq/mBIertumdOy2f9Zfn8TAO2rPd0vI5TfejItkUTwbm2ESNN3N
	Tae5YU/c2zyHS+y3V0boFn1Q115vzqQmnbp52TzHf2bXY2oc/zY/s0uc6Tx7zoyQebwdhm2v
	iyY4lK9TYinOSDTUYi4qTgQAJ6SrUyUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

Best Regards,
Jaehoon Chung

On 03/12/2013 07:43 PM, James Hogan wrote:
> Call the setpower platform callback in response to set_ios with
> ios->power_mode == MMC_POWER_UP or MMC_POWER_OFF, instead of from the
> card detect work function.
> 
> This appears to fix a problem I have where a card stuck in a funny state
> doesn't get properly cleared by the power being turned off, presumably
> due to lack of power sequencing. This resulted in the following log
> messages after boot:
> 
> mmc0: error -110 whilst initialising SD card
> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 300000Hz, actual 298922HZ div = 167)
> mmc0: error -110 whilst initialising SD card
> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 200000Hz, actual 199680HZ div = 250)
> mmc0: error -110 whilst initialising SD card
> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 195765Hz, actual 195764HZ div = 255)
> mmc0: error -110 whilst initialising SD card
> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 400000Hz, actual 399360HZ div = 125)
> mmc0: error -110 whilst initialising SD card
> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 300000Hz, actual 298922HZ div = 167)
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Seungwon Jeon <tgih.jun@samsung.com>
> Cc: Jaehoon Chung <jh80.chung@samsung.com>
> Cc: Chris Ball <cjb@laptop.org>
> ---
>  drivers/mmc/host/dw_mmc.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 60063cc..1a42c7c 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -818,6 +818,14 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  	switch (ios->power_mode) {
>  	case MMC_POWER_UP:
>  		set_bit(DW_MMC_CARD_NEED_INIT, &slot->flags);
> +		/* Power up slot */
> +		if (slot->host->pdata->setpower)
> +			slot->host->pdata->setpower(slot->id, mmc->ocr_avail);
> +		break;
> +	case MMC_POWER_OFF:
> +		/* Power down slot */
> +		if (slot->host->pdata->setpower)
> +			slot->host->pdata->setpower(slot->id, 0);
>  		break;
>  	default:
>  		break;
> @@ -1674,10 +1682,6 @@ static void dw_mci_work_routine_card(struct work_struct *work)
>  			dev_dbg(&slot->mmc->class_dev, "card %s\n",
>  				present ? "inserted" : "removed");
>  
> -			/* Power up slot (before spin_lock, may sleep) */
> -			if (present != 0 && host->pdata->setpower)
> -				host->pdata->setpower(slot->id, mmc->ocr_avail);
> -
>  			spin_lock_bh(&host->lock);
>  
>  			/* Card change detected */
> @@ -1760,10 +1764,6 @@ static void dw_mci_work_routine_card(struct work_struct *work)
>  
>  			spin_unlock_bh(&host->lock);
>  
> -			/* Power down slot (after spin_unlock, may sleep) */
> -			if (present == 0 && host->pdata->setpower)
> -				host->pdata->setpower(slot->id, 0);
> -
>  			present = dw_mci_get_cd(mmc);
>  		}
>  
> 

