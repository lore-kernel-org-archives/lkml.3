Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaFMHzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:55:40 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:44569 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaFMHzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:55:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19iGdT7RPJXhEwgZXi3/ne0
Date: Fri, 13 Jun 2014 00:55:28 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        kyungmin.park@samsung.com, pekon@ti.com,
        ezequiel.garcia@free-electrons.com, javier@dowhile0.org,
        nsekhar@ti.com, linux-omap@vger.kernel.org,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/36] ARM: OMAP2+: gpmc-onenand: Move Synchronous
 setting code to drivers/
Message-ID: <20140613075527.GP17845@atomide.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
 <1402477001-31132-19-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402477001-31132-19-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140611 01:59]:
> Move the code that puts the onenand in synchronous mode
> into the appropriate place i.e. drivers/mtd/onenand/omap2.c.
> 
> Make use of omap_gpmc_get_clk_period() and omap_gpmc_retime()
> to calculate the necessary timings and configure the GPMC
> parent's timings.

Ideally we would just use the drivers/mtd/onenand/generic.c
and get rid of drivers/mtd/onenand/omap2.c. We still need
the bus glue, which should probably be in drivers/memory?

Regards,

Tony
