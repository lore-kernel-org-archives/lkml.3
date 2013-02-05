Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab3BEPeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:34:21 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:63220 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754719Ab3BEPeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:34:20 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ZRtgo7wScHoIY3zINBScokkMOMGRN9tc=
Date: Tue, 5 Feb 2013 10:34:11 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Kirkwood: Add missing linux/i2c.h include
Message-ID: <20130205153411.GV14746@titan.lakedaemon.net>
References: <1360077025-8046-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360077025-8046-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry,

On Tue, Feb 05, 2013 at 04:10:25PM +0100, Thierry Reding wrote:
> The nsa310 board uses I2C_BOARD_INFO and i2c_register_board_info(), both
> of which are defined in the linux/i2c.h header file.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  arch/arm/mach-kirkwood/board-nsa310.c | 1 +
>  1 file changed, 1 insertion(+)

What is this based against?  We're in the process of removing this whole
file for v3.9 (pinctrl, mv643xx_eth, and i2c)...

thx,

Jason.

> 
> diff --git a/arch/arm/mach-kirkwood/board-nsa310.c b/arch/arm/mach-kirkwood/board-nsa310.c
> index 61c4b18..970174a 100644
> --- a/arch/arm/mach-kirkwood/board-nsa310.c
> +++ b/arch/arm/mach-kirkwood/board-nsa310.c
> @@ -11,6 +11,7 @@
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/gpio.h>
> +#include <linux/i2c.h>
>  #include <mach/kirkwood.h>
>  #include <linux/of.h>
>  #include "common.h"
> -- 
> 1.8.1.2
> 
