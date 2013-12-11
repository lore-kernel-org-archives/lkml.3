Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab3LKJsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:48:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49092 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3LKJsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:48:42 -0500
Date: Wed, 11 Dec 2013 10:48:38 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Felipe Balbi <balbi@ti.com>
Cc: lee.jones@linaro.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 01/15] mfd: menelaus: Drop __exit section annotation
Message-ID: <20131211094838.GH18888@pengutronix.de>
References: <20131209161422.GC24047@saruman.home>
 <1386606085-26838-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386606085-26838-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 10:21:11AM -0600, Felipe Balbi wrote:
> We could build that driver as a dynamically-linked module.
ups, only saw now the v3 after I commented on v2. So you addressed a
part of my comment already. Still building that driver as a module also
works without this patch, right? So this is only about hotplugging
(which usually doesn't work on i2c, so only via /sys/bus/i2c) and driver
unloading.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
