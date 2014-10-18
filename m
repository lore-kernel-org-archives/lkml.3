Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaJRQsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 12:48:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43470 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaJRQsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 12:48:20 -0400
Date: Sat, 18 Oct 2014 18:48:07 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Matthias Fuchs <matthias.fuchs@esd.eu>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] net: can: esd_usb2: fix memory leak on disconnect
Message-ID: <20141018164806.GA27828@pengutronix.de>
References: <1412973067-29707-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412973067-29707-1-git-send-email-khoroshilov@ispras.ru>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:47:40 up 3 days,  6:01, 42 users,  load average: 0.85, 2.52,
 13.27
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 12:31:07AM +0400, Alexey Khoroshilov wrote:
> It seems struct esd_usb2 dev is not deallocated on disconnect.
> 
> The patch adds the deallocation.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Applied to the can tree.

Thanks,
Marc

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
