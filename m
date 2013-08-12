Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3HLGE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 02:04:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49369 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3HLGE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 02:04:57 -0400
Date: Mon, 12 Aug 2013 08:04:44 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com
Subject: Re: [PATCH v6] linux,stdout-path helper
Message-ID: <20130812060444.GI26614@pengutronix.de>
References: <1375706445-15375-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375706445-15375-1-git-send-email-s.hauer@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:03:42 up 12 days, 15:07, 26 users,  load average: 0.04, 0.03,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Given that we have Robs Ack, can you take this series?

Sascha

On Mon, Aug 05, 2013 at 02:40:43PM +0200, Sascha Hauer wrote:
> The following adds a helper for matching the linux,stdout-path property
> in the chosen node and makes use of it in the i.MX serial
> 
> This is a series originally created by me. It was hijacked and then abandoned
> by Jean-Christophe for v5. I reverted the changes by Jean-Christophe since
> they introduced changes to the devicetree binding. Instead I'd like to have
> the existing binding implemented first before changing it.
> 
> Sascha
> 
> changes since v5:
> - reverted changes from v4
> - parse linux,stdoutpath property in of_alias_scan as suggested by Grant
> changes since v4:
> - add option support and check stdout-path too
> changes since v3:
> - move code from separate files to drivers/of/base.c and include/linux/of.h
> changes since v2:
> - move helper to OF core and make it independent of serial devices
> changes since v1:
> - move it out of the i.MX serial driver and make it generic for serial devices.
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
