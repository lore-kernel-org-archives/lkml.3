Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab3DLMzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 08:55:45 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37362 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab3DLMzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 08:55:43 -0400
Message-ID: <1365771339.4459.0.camel@edumazet-glaptop>
Subject: Re: [PATCH v2] net: mv643xx_eth: remove deprecated inet_lro support
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
Date: Fri, 12 Apr 2013 05:55:39 -0700
In-Reply-To: <1365758400-12565-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1365707488-28819-1-git-send-email-sebastian.hesselbarth@gmail.com>
	 <1365758400-12565-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-12 at 11:20 +0200, Sebastian Hesselbarth wrote:
> With recent support for GRO, there is no need to keep both LRO and
> GRO. This patch therefore removes the deprecated inet_lro support
> from mv643xx_eth. This is work is based on an experimental patch
> provided by Eric Dumazet and Willy Tarreau.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Based-on-patch-by: Eric Dumazet <eric.dumazet@gmail.com>
> Based-on-patch-by: Willy Tarreau <w@1wt.eu>
> ---
> Changes from v1:
> - also remove INET_LRO from Kconfig (Reported by Eric Dumazet)

Thanks for finishing this patch

Signed-off-by: Eric Dumazet <edumazet@google.com>


