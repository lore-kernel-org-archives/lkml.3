Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaAFR16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 12:27:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59936 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbaAFR1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:27:55 -0500
Message-ID: <1389029271.5590.20.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v2] drivers: reset: Mark function as static and remove
 unused function in core.c
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shawn Guo <shawn.guo@linaro.org>, josh@joshtriplett.org
Date: Mon, 06 Jan 2014 18:27:51 +0100
In-Reply-To: <20131219084110.GA14098@rashika>
References: <20131219084110.GA14098@rashika>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 19.12.2013, 14:11 +0530 schrieb Rashika Kheria:
> Mark function of_reset_simple_xlate() as static in core.c
> because it is not used outside this file.
> Also, remove functions devm_reset_control_put() and
> devm_reset_control_match() because they are unused.
> 
> This eliminates the following warnings in core.c:
> drivers/reset/core.c:46:5: warning: no previous prototype for ‘of_reset_simple_xlate’ [-Wmissing-prototypes]
> drivers/reset/core.c:262:6: warning: no previous prototype for ‘devm_reset_control_put’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
> 
> Changes since v1:
> Incorrect Fix
[...]

I have overlooked this earlier, will apply it as-is.

thanks
Philipp

