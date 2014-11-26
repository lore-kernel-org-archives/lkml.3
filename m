Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaKZP7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:59:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47445 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaKZP7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:59:23 -0500
Date: Wed, 26 Nov 2014 16:59:20 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Sekhar Nori <nsekhar@ti.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Mike Looijmans <milo-software@users.sourceforge.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH v2 4/5] i2c: davinci: use bus recovery infrastructure
Message-ID: <20141126155920.GM4431@pengutronix.de>
References: <1417010393-30598-1-git-send-email-grygorii.strashko@ti.com>
 <1417010393-30598-5-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417010393-30598-5-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


On Wed, Nov 26, 2014 at 03:59:52PM +0200, Grygorii Strashko wrote:
> This patch converts Davinci I2C driver to use I2C bus recovery
> infrastructure, introduced by commit 5f9296ba21b3 ("i2c: Add
> bus recovery infrastructure").
> 
> The i2c_bus_recovery_info is configured for Davinci I2C adapter
> only in case if scl_pin is provided in platform data at least.
My German feeling for English tells me:
s/if//; s/at least//;

With that changed you can add my Ack.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
