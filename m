Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab3GWORi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 10:17:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57727 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932972Ab3GWORg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 10:17:36 -0400
Date: Tue, 23 Jul 2013 16:17:27 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5] linux,stdout-path helper
Message-ID: <20130723141727.GA6807@pengutronix.de>
References: <20121121155312.GX4398@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121155312.GX4398@game.jcrosoft.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:16:37 up 40 days,  2:26, 26 users,  load average: 0.20, 0.33,
 0.23
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 04:53:12PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> The following adds a helper for matching the linux,stdout-path property
> in the chosen node and makes use of it in the i.MX serial and Atmel serial driver.

Seems this got stuck. Jean-Christophe, will you update this series? I
could really make use of this.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
