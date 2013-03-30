Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab3C3Uu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 16:50:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:31999 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750Ab3C3Uu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 16:50:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18hdvcgQOilBo9uUZBGDPem0SIMB4y+1aA=
Date: Sat, 30 Mar 2013 16:50:30 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Soeren Moch <smoch@web.de>,
        Willy Tarreau <w@1wt.eu>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: kirkwood: make use of DT mvsdio on guruplug board
Message-ID: <20130330205030.GX13280@titan.lakedaemon.net>
References: <1364043489-17683-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364043489-17683-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 01:58:09PM +0100, Sebastian Hesselbarth wrote:
> Device tree based guruplug boards still use mvsdio platform_data and
> kirkwood_sdio_init to enable sdio. DT support for sdio is already there,
> so make use of it.
> 
> This also fixes mvsdio accidentially breaking nand by configuring mpp0
> to gpio, while used also by nand (nand_io2 on mpp0).
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Tested-by: Soeren Moch <smoch@web.de>
> ---
> Cc: Soeren Moch <smoch@web.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts |    4 ++++
>  arch/arm/mach-kirkwood/board-guruplug.c             |    6 ------
>  2 files changed, 4 insertions(+), 6 deletions(-)

Applied to mvebu/dt

thx,

Jason.
