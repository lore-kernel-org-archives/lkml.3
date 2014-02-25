Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaBYNG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 08:06:56 -0500
Received: from mout.gmx.net ([212.227.15.18]:63159 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbaBYNGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 08:06:54 -0500
From: Marc Dietrich <marvin24@gmx.de>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, Chen-Yu Tsai <wens@csie.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCHv2 1/5] ARM: tegra: remove obsolete gpio entries
Date: Tue, 25 Feb 2014 14:06:45 +0100
Message-ID: <5570705.i8uRb6OetD@fb07-iapwap2>
User-Agent: KMail/4.12.2 (Linux/3.14.0-rc3-12.gfc9498b-desktop+; KDE/4.12.2; x86_64; ; )
In-Reply-To: <1393330950-7283-2-git-send-email-heikki.krogerus@linux.intel.com>
References: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com> <1393330950-7283-2-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
X-Provags-ID: V03:K0:ZUGAxe0GJrbgyGwyel2vBsqeobkMMS2fbMojjGhnE3y9VtlhyTC
 8Kw0sptpQDsJ/npVPuNUi9ipc+Q88RArikrcb7A8uXzMgPpcVC7spCWIj3pU8dYCNAUCLMK
 H90h/CivjPlWqKI3zirkjA7NCPixDofmZ4qwifdFnfVRR5C0JujmGEQx+AX6WqeDNPEDPhY
 Hhg4qFbr7oK72/mPN4rAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heikki,

Am Dienstag, 25. Februar 2014, 14:22:26 schrieb Heikki Krogerus:
> After moving to description based gpio interface in
> rfkill-gpio, the gpio numbers are not used any more.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Reviewed-by: Marc Dietrich <marvin24@gmx.de>

Thanks for taking care!

Marc

> ---
>  arch/arm/mach-tegra/board-paz00.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/board-paz00.c
> b/arch/arm/mach-tegra/board-paz00.c index e4dec9f..9c6029b 100644
> --- a/arch/arm/mach-tegra/board-paz00.c
> +++ b/arch/arm/mach-tegra/board-paz00.c
> @@ -23,9 +23,7 @@
>  #include "board.h"
> 
>  static struct rfkill_gpio_platform_data wifi_rfkill_platform_data = {
> -	.name		= "wifi_rfkill",
> -	.reset_gpio	= 25, /* PD1 */
> -	.shutdown_gpio	= 85, /* PK5 */
> +	.name	= "wifi_rfkill",
>  	.type	= RFKILL_TYPE_WLAN,
>  };

