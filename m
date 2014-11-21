Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaKUSt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:49:27 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34405 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaKUSt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:49:26 -0500
Date: Fri, 21 Nov 2014 19:49:22 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [3/5] i2c: recovery: change input parameter to i2c_adapter for
 prepare/unprepare_recovery
Message-ID: <20141121184922.GA4431@pengutronix.de>
References: <1416477788-5544-4-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416477788-5544-4-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 12:03:06PM +0200, Grygorii Strashko wrote:
> This patch changes type of input parameter for .prepare/unprepare_recovery()
> callbacks from struct i2c_bus_recovery_info * to struct i2c_adapter *.
> This allows to simplify implementation of these callbacks and avoid
> type conversations from i2c_bus_recovery_info to i2c_adapter.
> The i2c_bus_recovery_info can be simply retrieved from struct i2c_adapter
> which contains pointer on it.
> 
> CC: Sekhar Nori <nsekhar@ti.com>
> CC: Kevin Hilman <khilman@deeprootsystems.com>
> CC: Santosh Shilimkar <ssantosh@kernel.org>
> CC: Murali Karicheri <m-karicheri2@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Sounds and looks sensible

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
