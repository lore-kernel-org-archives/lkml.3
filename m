Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaF0Mzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:55:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53270 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbaF0Mzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:55:51 -0400
Date: Fri, 27 Jun 2014 14:55:15 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
Cc: robh+dt@kernel.org, Peter.Chen@freescale.com, gregkh@linuxfoundation.org,
        galak@codeaurora.org, rdunlap@infradead.org, michal.simek@xilinx.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kpc528@gmail.com,
        kalluripunnaiahchoudary@gmail.com,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: Re: [PATCH v2 2/2] usb: chipidea: Add support for zynq usb host and
 device controller
Message-ID: <20140627125515.GA6025@pengutronix.de>
References: <1403868233-5123-1-git-send-email-punnaia@xilinx.com>
 <fa656d2d-a2a8-4b8d-a29b-e89e4bfced3e@BL2FFO11FD034.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa656d2d-a2a8-4b8d-a29b-e89e4bfced3e@BL2FFO11FD034.protection.gbl>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:51:48 up 65 days,  6:23, 61 users,  load average: 0,23, 0,21,
 0,16
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 27, 2014 at 04:53:53PM +0530, Punnaiah Choudary Kalluri wrote:
> Zynq soc uses Chipidea/Synopsys usb IP core(CI13612). This patch adds
> necessary glue to allow the chipidea driver to work on zynq soc.
> 

Did you see the currently discussed patches for the generic chipidea
glue?

http://www.spinics.net/lists/linux-usb/msg109576.html

Try to improve that code instead writing another version
of this simple gluecode.


Thanks,
Michael


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
