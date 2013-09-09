Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3IIQKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:10:24 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:60238 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3IIQKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:10:20 -0400
Message-ID: <522DF2EA.2090106@lwfinger.net>
Date: Mon, 09 Sep 2013 11:10:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: farisdehaan@gmail.com
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8188eu: checkpatch.pl warnings removed
References: <522dea9f.47250e0a.0f3f.ffffc2dc@mx.google.com>
In-Reply-To: <522dea9f.47250e0a.0f3f.ffffc2dc@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 10:34 AM, farisdehaan@gmail.com wrote:
> From: Faris de Haan <farisdehaan@gmail.com>
>
> Fixed some of the coding style issues reported by checkpatch.pl
>
> Signed-off-by: Faris de Haan <farisdehaan@gmail.com>
> ---
>   drivers/staging/rtl8188eu/core/rtw_sta_mgt.c |    7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
> index c2977be..cd3c9a7 100644
> --- a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
> +++ b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
> @@ -267,9 +267,8 @@ _func_enter_;
>
>   		rtw_mfree_sta_priv_lock(pstapriv);
>
> -		if (pstapriv->pallocated_stainfo_buf) {
> +		if (pstapriv->pallocated_stainfo_buf)
>   			rtw_vmfree(pstapriv->pallocated_stainfo_buf, sizeof(struct sta_info)*NUM_STA+4);
> -		}
>   	}
>
>   _func_exit_;
> @@ -315,7 +314,7 @@ _func_enter_;
>
>   		rtw_list_insert_tail(&psta->hash_list, phash_list);
>
> -		pstapriv->asoc_sta_count++ ;
> +		pstapriv->asoc_sta_count++;
>
>   		_exit_critical_bh(&(pstapriv->sta_hash_lock), &irql2);
>
> @@ -419,7 +418,7 @@ _func_enter_;
>   	_cancel_timer_ex(&psta->addba_retry_timer);
>
>   	/* for A-MPDU Rx reordering buffer control, cancel reordering_ctrl_timer */
> -	for (i = 0; i < 16 ; i++) {
> +	for (i = 0; i < 16; i++) {
>   		unsigned long irql;
>   		struct list_head *phead, *plist;
>   		union recv_frame *prframe;
>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

