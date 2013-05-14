Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab3ENHCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:02:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55336 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3ENHCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:02:04 -0400
Date: Tue, 14 May 2013 09:01:47 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        hein_tibosch@yahoo.es, michal.simek@xilinx.com,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net/macb: fix ISR clear-on-write behavior only for
 some SoC
Message-ID: <20130514070147.GB29391@pengutronix.de>
References: <1368461105-23128-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368461105-23128-1-git-send-email-nicolas.ferre@atmel.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:58:44 up 65 days, 16:39, 19 users,  load average: 0.69, 0.42,
 0.25
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, May 13, 2013 at 06:05:05PM +0200, Nicolas Ferre wrote:
> Commit 749a2b6 (net/macb: clear tx/rx completion flags in ISR)
> introduces clear-on-write on ISR register. This behavior is not always
> implemented when using Cadence MACB/GEM and is breaking other platforms.
> We are using a new Device Tree compatibility string and a capability
> property to actually activate this clear-on-write behavior on ISR.
> 
> Reported-by: Hein Tibosch <hein_tibosch@yahoo.es>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  Documentation/devicetree/bindings/net/macb.txt |  2 ++
>  drivers/net/ethernet/cadence/macb.c            | 15 +++++++++++++--
>  drivers/net/ethernet/cadence/macb.h            |  5 +++++
>  3 files changed, 20 insertions(+), 2 deletions(-)
> 

Looks okay to me:

Acked-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>

Thanks,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
