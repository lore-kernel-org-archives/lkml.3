Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbbAWJrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:47:05 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:58427 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbbAWJq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:46:59 -0500
MIME-Version: 1.0
In-Reply-To: <1422005800-13442-1-git-send-email-md.jamalmohiuddin@gmail.com>
References: <1422005800-13442-1-git-send-email-md.jamalmohiuddin@gmail.com>
Date: Fri, 23 Jan 2015 15:16:58 +0530
Message-ID: <CAEUmHybQkyR7_TqOstDFcU=7iohL8E8ZaQYSNPiZC+MCi=hLmA@mail.gmail.com>
Subject: Re: [PATCH] net: ieee802154: cc2520: fix coding style issue
From: Varka Bhadram <varkabhadram@gmail.com>
To: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Cc: Alexander Aring <alex.aring@gmail.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mohammad Jamal,

On Fri, Jan 23, 2015 at 3:06 PM, Mohammad Jamal
<md.jamalmohiuddin@gmail.com> wrote:
> This patch solves the coding style issue warning
> by replacing the shifting operations by BIT macro
>
> Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
> ---
>  drivers/net/ieee802154/cc2520.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
> index dd129be..b9b2a49 100644
> --- a/drivers/net/ieee802154/cc2520.c
> +++ b/drivers/net/ieee802154/cc2520.c
> @@ -45,9 +45,9 @@
>  #define        CC2520_FREG_MASK        0x3F
>
>  /* status byte values */
> -#define        CC2520_STATUS_XOSC32M_STABLE    (1 << 7)
> -#define        CC2520_STATUS_RSSI_VALID        (1 << 6)
> -#define        CC2520_STATUS_TX_UNDERFLOW      (1 << 3)
> +#define        CC2520_STATUS_XOSC32M_STABLE    BIT(7)
> +#define        CC2520_STATUS_RSSI_VALID        BIT(6)
> +#define        CC2520_STATUS_TX_UNDERFLOW      BIT(3)
>
>  /* IEEE-802.15.4 defined constants (2.4 GHz logical channels) */
>  #define        CC2520_MINCHANNEL               11
> --
> 1.7.9.5
>

Please work on bluetooth-next[1] tree and also include
'bluetooth-next' tag for the patch.

[1]: http://git.kernel.org/cgit/linux/kernel/git/bluetooth/bluetooth-next.git/

-- 
Thanks and Regards,
Varka Bhadram.
