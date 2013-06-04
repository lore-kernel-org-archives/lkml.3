Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab3FDNkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:40:41 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:57660 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab3FDNkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:40:37 -0400
Date: Tue, 4 Jun 2013 15:40:34 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Roese <sr@denx.de>, Richard Genoud <richard.genoud@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: sun4i-emac: remove erroneous assignment
Message-ID: <20130604134034.GE3283@lukather>
References: <3298610.K0DeJZEM4E@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3298610.K0DeJZEM4E@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, Jun 03, 2013 at 11:36:50PM +0200, Arnd Bergmann wrote:
> The newly added sun4i-emac driver causes a build error when
> CONFIG_NET_POLL_CONTROLLER is set, because it attempts to
> assign a pointer to netdev->poll_controller, which has
> been replaced with ops->ndo_poll_controller in 2.6.31!
> 
> The correct assignment is present as well, so we just need
> to remove the wrong one.

Thanks for fixing this,
Acked-by: Maxime Ripard <maxime.ripard@anandra.org>

Maxime
