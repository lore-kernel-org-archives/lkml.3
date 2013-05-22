Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3EVQQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:16:35 -0400
Received: from londo.lunn.ch ([80.238.139.98]:41421 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290Ab3EVQQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:16:34 -0400
Date: Wed, 22 May 2013 18:16:21 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/12] net: mv643xx_eth DT support and fixes
Message-ID: <20130522161621.GM2824@lunn.ch>
References: <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 06:41:38PM +0200, Sebastian Hesselbarth wrote:
> This patch set picks up work by Florian Fainelli bringing full DT
> support to mv643xx_eth and Marvell SoCs using it.

Hi Sebastian

I tested on my QNAP and topkick. Works great.

Tested-by: Andrew Lunn <andrew@lunn.ch>

   Andrew
