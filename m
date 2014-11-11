Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaKKTOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:14:34 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37695 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaKKTOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:14:32 -0500
Message-ID: <54626015.3030907@gmail.com>
Date: Tue, 11 Nov 2014 11:14:29 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Johan Hovold <johan@kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] net: phy: add module_phy_driver macro
References: <1415731559-10015-1-git-send-email-johan@kernel.org>
In-Reply-To: <1415731559-10015-1-git-send-email-johan@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 10:45 AM, Johan Hovold wrote:
> Add module_phy_driver macro that can be used by PHY drivers that only
> calls phy_driver_register or phy_drivers_register (and the corresponding
> unregister functions) in their module init (and exit).
> 
> This allows us to eliminate a lot of boilerplate code.
> 
> Split in three patches (actual macro and two driver change classes) in
> order to facilitate review.

Looks good to me:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!

> 
> Johan
> 
> 
> Johan Hovold (3):
>   net: phy: add module_phy_driver macro
>   net: phy: replace phy_driver_register calls
>   net: phy: replace phy_drivers_register calls
> 
>  drivers/net/phy/amd-xgbe-phy.c | 15 +--------------
>  drivers/net/phy/amd.c          | 17 +++--------------
>  drivers/net/phy/at803x.c       | 14 +-------------
>  drivers/net/phy/bcm63xx.c      | 15 +--------------
>  drivers/net/phy/bcm7xxx.c      | 15 +--------------
>  drivers/net/phy/bcm87xx.c      | 14 +-------------
>  drivers/net/phy/broadcom.c     | 15 +--------------
>  drivers/net/phy/cicada.c       | 15 +--------------
>  drivers/net/phy/davicom.c      | 15 +--------------
>  drivers/net/phy/et1011c.c      | 17 +++--------------
>  drivers/net/phy/icplus.c       | 15 +--------------
>  drivers/net/phy/lxt.c          | 15 +--------------
>  drivers/net/phy/marvell.c      | 15 +--------------
>  drivers/net/phy/micrel.c       | 15 +--------------
>  drivers/net/phy/national.c     | 17 +++--------------
>  drivers/net/phy/qsemi.c        | 17 +++--------------
>  drivers/net/phy/realtek.c      | 13 +------------
>  drivers/net/phy/smsc.c         | 14 +-------------
>  drivers/net/phy/ste10Xp.c      | 15 +--------------
>  drivers/net/phy/vitesse.c      | 14 +-------------
>  include/linux/phy.h            | 24 ++++++++++++++++++++++++
>  21 files changed, 52 insertions(+), 274 deletions(-)
> 

