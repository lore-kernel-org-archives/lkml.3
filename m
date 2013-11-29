Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab3K2PYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:24:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37146 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab3K2PYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:24:09 -0500
Date: Fri, 29 Nov 2013 16:24:04 +0100
From: Michael Grzeschik <mgr@pengutronix.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        s.nawrocki@samsung.com, shc_work@mail.ru, kernel@pengutronix.de
Subject: Re: [PATCH] mfd: syscon: add inline nop functions to compile without
 option
Message-ID: <20131129152404.GE3516@pengutronix.de>
References: <1385738156-31852-1-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385738156-31852-1-git-send-email-m.grzeschik@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:20:46 up 70 days,  3:08, 48 users,  load average: 12,56, 12,76,
 12,88
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 29, 2013 at 04:15:56PM +0100, Michael Grzeschik wrote:
> The syscon interface can be used in different drivers to reach registers
> of other register range via phandle. The exported functions can only be
> used if the syscon interface is enabled. This patch fixes this by
> adding nop functions if the syscon is not selected in the config.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---

forget this patch. It is already mainlined by Peter Chen.


Thanks,
Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
