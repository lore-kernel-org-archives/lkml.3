Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab3KXQ7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 11:59:44 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:47020 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752855Ab3KXQ7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 11:59:42 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19kgQL6EorhGWXy7wTh0jZEviAlUZ7rTA4=
Date: Sun, 24 Nov 2013 11:59:32 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: kirkwood: provide pinctrl default to sdio
 nodes
Message-ID: <20131124165932.GG29241@titan.lakedaemon.net>
References: <1384525225-591-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384525225-591-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 03:20:24PM +0100, Sebastian Hesselbarth wrote:
> SDIO controllers found on Marvell Kirkwood 6281/6282 SoCs require
> pins to be muxed by pinctrl. As there is only one sane pinctrl
> setting for this, provide default pinctrl properties to the controller
> nodes.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> I am not sending this two patches to each DT maintainer, as it is a
> Kirkwood only thing, added the dt list for completeness.
> 
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/kirkwood-6281.dtsi |    2 ++
>  arch/arm/boot/dts/kirkwood-6282.dtsi |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)

Series applied to mvebu/dt

thx,

Jason.
