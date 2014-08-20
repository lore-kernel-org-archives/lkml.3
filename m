Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaHTMA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:00:58 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:46218 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaHTMAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:00:55 -0400
Message-ID: <53F48DF3.8000705@cogentembedded.com>
Date: Wed, 20 Aug 2014 16:00:51 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org
CC: nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] r8152: remove clear_bp function
References: <1394712342-15778-16-Taiwan-albertk@realtek.com> <1394712342-15778-19-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-19-Taiwan-albertk@realtek.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 8/20/2014 12:58 PM, Hayes Wang wrote:

> The functions are used to update the firmware. Move the actions into
> the firmware files.

> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>   drivers/net/usb/r8152.c | 24 ------------------------
>   1 file changed, 24 deletions(-)

> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 33dcc97..937d132 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
[...]
> @@ -2248,7 +2226,6 @@ static void r8152b_hw_phy_cfg(struct r8152 *tp)
>
>   	r8152b_disable_aldps(tp);
>
> -	rtl_clear_bp(tp);
>

    Why leave 2 empty lines? One is enough.

>   	r8152b_enable_aldps(tp);
>   	set_bit(PHY_RESET, &tp->flags);
> @@ -2404,7 +2381,6 @@ static void r8153_hw_phy_cfg(struct r8152 *tp)
>   		r8152_mdio_write(tp, MII_BMCR, data);
>   	}
>
> -	r8153_clear_bp(tp);
>

    Ditto.

>   	if (tp->version == RTL_VER_03) {
>   		data = ocp_reg_read(tp, OCP_EEE_CFG);
>

WBR, Sergei

