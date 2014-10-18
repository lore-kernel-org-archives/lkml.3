Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaJRQaY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 12:30:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45666 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaJRQaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 12:30:22 -0400
Date: Sat, 18 Oct 2014 18:30:02 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: wg@grandegger.com, linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] net: m_can: add CONFIG_HAS_IOMEM dependence
Message-ID: <20141018163001.GA24931@pengutronix.de>
References: <1413409310-14117-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413409310-14117-1-git-send-email-david.a.cohen@linux.intel.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:29:02 up 3 days,  5:43, 40 users,  load average: 40.72, 85.40,
 43.27
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 02:41:50PM -0700, David Cohen wrote:
> m_can uses io memory which makes it not compilable on architectures
> without HAS_IOMEM such as UML:
> 
> drivers/built-in.o: In function `m_can_plat_probe':
> m_can.c:(.text+0x218cc5): undefined reference to `devm_ioremap_resource'
> m_can.c:(.text+0x218df9): undefined reference to `devm_ioremap'
> 
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>

Applied to the can tree.

Thanks,
Marc

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
