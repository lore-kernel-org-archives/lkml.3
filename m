Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab3DKTrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:47:01 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44145 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3DKTrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:47:00 -0400
Message-ID: <1365709617.3887.185.camel@edumazet-glaptop>
Subject: Re: [PATCH] net: mv643xx_eth: remove deprecated inet_lro support
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Florian Fainelli <florian@openwrt.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Dale Farnsworth <dale@farnsworth.org>,
        Ben Hutchings <bhutchings@solarflare.com>, Soeren Moch <smoch@web.de>,
        Willy Tarreau <w@1wt.eu>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Thu, 11 Apr 2013 12:46:57 -0700
In-Reply-To: <1365707488-28819-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1365707488-28819-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 21:11 +0200, Sebastian Hesselbarth wrote:
> With recent support for GRO, there is no need to keep both LRO and
> GRO. This patch therefore removes the deprecated inet_lro support
> from mv643xx_eth. This is work is based on an experimental patch
> provided by Eric Dumazet and Willy Tarreau.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Based-on-patch-by: Eric Dumazet <eric.dumazet@gmail.com>
> Based-on-patch-by: Willy Tarreau <w@1wt.eu>
> ---
> Note: This patch is based upon recent cleanup patches and GRO support
> patch for mv643xx_eth.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Lennert Buytenhek <buytenh@wantstofly.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Florian Fainelli <florian@openwrt.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Dale Farnsworth <dale@farnsworth.org>
> Cc: Ben Hutchings <bhutchings@solarflare.com>
> Cc: Soeren Moch <smoch@web.de>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/net/ethernet/marvell/mv643xx_eth.c |   97 +---------------------------
>  1 file changed, 3 insertions(+), 94 deletions(-)

Seems fine to me, but you also could remove "select INET_LRO"
from drivers/net/ethernet/marvell/Kconfig


