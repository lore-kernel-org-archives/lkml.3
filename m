Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbaAJKHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:07:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53815 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaAJKHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:07:19 -0500
Date: Fri, 10 Jan 2014 11:06:50 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolin Chen <Guangyu.Chen@freescale.com>, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, rob@landley.net, mturquette@linaro.org
Subject: Re: [PATCH] ARM: imx6q: Add missing esai_ahb clock to current clock
 tree
Message-ID: <20140110100650.GA16215@pengutronix.de>
References: <1389236699-10387-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140109075525.GO6750@pengutronix.de>
 <20140109150141.GD27432@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109150141.GD27432@n2100.arm.linux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:05:42 up 138 days, 19:36, 55 users,  load average: 0.39, 1.27,
 0.92
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Thu, Jan 09, 2014 at 03:01:41PM +0000, Russell King - ARM Linux wrote:
> Sascha, your messages have the Mail-Followup-To: header...
> 
> Mail-Followup-To: Nicolin Chen <Guangyu.Chen@freescale.com>,                    
>         shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,    
>         linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,     
>         rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,      
>         ijc+devicetree@hellion.org.uk, galak@codeaurora.org,                    
>         devicetree@vger.kernel.org, rob@landley.net, mturquette@linaro.org      
> 
> resulting in me (and others) getting mails marked as To: me where they're
> not supposed to be To: me in the first place.

This should be fixed with this mail.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
