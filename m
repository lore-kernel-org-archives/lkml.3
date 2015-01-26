Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbbAZOFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:05:47 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40430 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbbAZOFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:05:44 -0500
Message-ID: <54C649B2.6020902@gmail.com>
Date: Mon, 26 Jan 2015 19:35:38 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mohammad Jamal <md.jamalmohiuddin@gmail.com>, alex.aring@gmail.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bluetooth-next] ieee802154: cc2520: Fix space before ,
 coding style issue
References: <1422021327-18815-1-git-send-email-md.jamalmohiuddin@gmail.com>
In-Reply-To: <1422021327-18815-1-git-send-email-md.jamalmohiuddin@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jamal,

On Friday 23 January 2015 07:25 PM, Mohammad Jamal wrote:
> This patch removes the warnings (space before , ) shown by
> checkpatch.pl

Thanks for the patch.

Acked-by: Varka Bhadram <varkabhadram@gmail.com>

>
> Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
> ---
>   drivers/net/ieee802154/cc2520.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
> index a43c8ac..665a3db 100644
> --- a/drivers/net/ieee802154/cc2520.c
> +++ b/drivers/net/ieee802154/cc2520.c
> @@ -549,14 +549,14 @@ cc2520_ed(struct ieee802154_hw *hw, u8 *level)
>   	u8 rssi;
>   	int ret;
>   
> -	ret = cc2520_read_register(priv , CC2520_RSSISTAT, &status);
> +	ret = cc2520_read_register(priv, CC2520_RSSISTAT, &status);
>   	if (ret)
>   		return ret;
>   
>   	if (status != RSSI_VALID)
>   		return -EINVAL;
>   
> -	ret = cc2520_read_register(priv , CC2520_RSSI, &rssi);
> +	ret = cc2520_read_register(priv, CC2520_RSSI, &rssi);
>   	if (ret)
>   		return ret;
>   

-- 
Thanks and Regards,
Varka Bhadram.

