Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaGUIP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:15:27 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64399 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaGUIPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:15:24 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, joe@perches.com,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 15/30] carl9170: remove unnecessary break after return
Date: Mon, 21 Jul 2014 10:15:07 +0200
Message-ID: <3022358.4W3VLEbhdR@blech>
User-Agent: KMail/4.12.4 (Linux/3.16.0-rc5-wl+; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1405866332-24652-6-git-send-email-fabf@skynet.be>
References: <1405866332-24652-1-git-send-email-fabf@skynet.be> <1405866332-24652-6-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 20, 2014 04:25:16 PM Fabian Frederick wrote:
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
>  drivers/net/wireless/ath/carl9170/phy.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
> index ab4ee7d..b80b213 100644
> --- a/drivers/net/wireless/ath/carl9170/phy.c
> +++ b/drivers/net/wireless/ath/carl9170/phy.c
> @@ -1139,7 +1139,6 @@ static int carl9170_set_freq_cal_data(struct ar9170 *ar,
>  
>  	default:
>  		return -EINVAL;
> -		break;
>  	}
>  
>  	for (; i >= 0; i--) {
> 

