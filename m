Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbaI2O6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:58:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48259 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753905AbaI2O55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:57:57 -0400
Date: Mon, 29 Sep 2014 16:57:53 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com,
        balbi@ti.com, p.zabel@pengutronix.de,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140929145753.GC8912@kwain>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <1411468088-5702-8-git-send-email-antoine.tenart@free-electrons.com>
 <1a0ed130-a53d-42df-9f6a-994c5b68755c@BN1BFFO11FD031.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a0ed130-a53d-42df-9f6a-994c5b68755c@BN1BFFO11FD031.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 04:58:14PM -0700, Sören Brinkmann wrote:
> On Tue, 2014-09-23 at 12:28PM +0200, Antoine Tenart wrote:
> > Add a USB2 ChipIdea driver for ci13xxx, with optional PHY, clock
> > and DMA mask, to support USB2 ChipIdea controllers that don't need
> > specific functions.
> > 
> > Tested on the Marvell Berlin SoCs USB controllers.
> > 
> > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> 
> This driver also works for Zynq. I didn't do extensive testing, but I
> could access a flash drive successfully.
> 
> Tested-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Thanks!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
