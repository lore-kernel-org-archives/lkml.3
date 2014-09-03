Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbaICNiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:38:25 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41771 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755478AbaICNiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:38:23 -0400
Date: Wed, 3 Sep 2014 14:38:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Anand Moon <moon.linux@yahoo.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Nimrod Andy <B38611@freescale.com>, Frank Li <frank.li@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        fugang.duan@freescale.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v2 fec_main iMX6Q DMA-API: device driver tries to free
	DMA memory it has not allocated
Message-ID: <20140903133805.GZ30401@n2100.arm.linux.org.uk>
References: <1409746850-30850-1-git-send-email-moon.linux@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409746850-30850-1-git-send-email-moon.linux@yahoo.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 05:50:50PM +0530, Anand Moon wrote:
> Check was added to check dma address should not be 0x0000000000000000
> before unmap the dma.
>  v1: remove unnecessary of bdp->cbd_bufaddr as suggested
>  by  Andy <fugang.duan@freescale.com>

I still have a whole pile of commits, one of them cleans up the handling
of this stuff.  Please hold off on this for the time being until I can
dig out the appropriate commit.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
