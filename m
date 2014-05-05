Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaEEBD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 21:03:56 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:38828 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaEEBDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 21:03:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18qJpiDLkgxAR+fB/9Z56Ytl0N2LUqs9lc=
X-DKIM: OpenDKIM Filter v2.0.1 titan 1F3B256B709
Date: Sun, 4 May 2014 21:03:44 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        Andrew Lunn <andrew@lunn.ch>, Huang Shijie <b32955@freescale.com>,
        linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v2 08/12] ARM: marvell: add MTD_SPI_NOR (new dependency
 for M25P80)
Message-ID: <20140505010344.GE28159@titan.lakedaemon.net>
References: <1398925607-7482-1-git-send-email-computersforpeace@gmail.com>
 <1398925607-7482-9-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398925607-7482-9-git-send-email-computersforpeace@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 11:26:43PM -0700, Brian Norris wrote:
> These defconfigs contain the CONFIG_M25P80 symbol, which is now
> dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to satisfy
> the new dependency.
> 
> At the same time, drop the now-nonexistent CONFIG_MTD_CHAR symbol.
> 
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Jason Cooper <jason@lakedaemon.net>
> ---
>  arch/arm/configs/dove_defconfig     | 2 +-
>  arch/arm/configs/kirkwood_defconfig | 1 +
>  arch/arm/configs/mvebu_v5_defconfig | 1 +
>  arch/arm/configs/mvebu_v7_defconfig | 1 +
>  4 files changed, 4 insertions(+), 1 deletion(-)

Applied to mvebu/defconfig with Ezequiel's Ack, and a reworded subject:

"ARM: mvebu: defconfig: add MTD_SPI_NOR (new dependency for M25P80)"

thx,

Jason.
