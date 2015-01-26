Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbbAZOEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:04:33 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55225 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbbAZOE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:04:29 -0500
Message-ID: <54C64962.2070204@gmail.com>
Date: Mon, 26 Jan 2015 19:34:18 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mohammad Jamal <md.jamalmohiuddin@gmail.com>, alex.aring@gmail.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bluetooth-next] ieee802154: cc2520: Replace shift operations
 by BIT macro
References: <1422021509-18877-1-git-send-email-md.jamalmohiuddin@gmail.com>
In-Reply-To: <1422021509-18877-1-git-send-email-md.jamalmohiuddin@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jamal,

On Friday 23 January 2015 07:28 PM, Mohammad Jamal wrote:
> This patch replaces the shifting operations by BIT macro

Thanks for the patch.

Acked-by: Varka Bhadram <varkabhadram@gmail.com>

> Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
> ---
>   drivers/net/ieee802154/cc2520.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
> index 665a3db..181b349 100644
> --- a/drivers/net/ieee802154/cc2520.c
> +++ b/drivers/net/ieee802154/cc2520.c
> @@ -44,9 +44,9 @@
>   #define	CC2520_FREG_MASK	0x3F
>   
>   /* status byte values */
> -#define	CC2520_STATUS_XOSC32M_STABLE	(1 << 7)
> -#define	CC2520_STATUS_RSSI_VALID	(1 << 6)
> -#define	CC2520_STATUS_TX_UNDERFLOW	(1 << 3)
> +#define	CC2520_STATUS_XOSC32M_STABLE	BIT(7)
> +#define	CC2520_STATUS_RSSI_VALID	BIT(6)
> +#define	CC2520_STATUS_TX_UNDERFLOW	BIT(3)
>   
>   /* IEEE-802.15.4 defined constants (2.4 GHz logical channels) */
>   #define	CC2520_MINCHANNEL		11

-- 
Thanks and Regards,
Varka Bhadram.

