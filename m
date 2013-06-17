Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3FQICd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:02:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41599 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab3FQIC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:02:29 -0400
Date: Mon, 17 Jun 2013 10:02:19 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Dinh Nguyen <dinguyen@altera.com>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/4] Zynq: Support more boards
Message-ID: <20130617080219.GA2062@pengutronix.de>
References: <1371141438-16553-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1371141438-16553-1-git-send-email-soren.brinkmann@xilinx.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:57:33 up 3 days, 20:07, 19 users,  load average: 0.00, 0.03,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 09:37:14AM -0700, Soren Brinkmann wrote:
> Just another respin. Still depending on armsoc/zynq/clk
> 
> 	Sören
> 
> v3:
>  - adding patch to use 'status' property for UART nodes
>  - dropping board specific compat string in the Zed dts
> 
> v2:
>  - adding patch to remove board specific compat strings from the BSP
>  - adding patch adding Zed support
> 
> Soren Brinkmann (4):
>   arm: zynq: Remove board specific compatibility string
>   arm: dt: zynq: Use 'status' property for UART nodes
>   arm: dt: zynq: Add support for the zc706 platform
>   arm: dt: zynq: Add support for the zed platform
> 
>  arch/arm/boot/dts/Makefile       |  4 +++-
>  arch/arm/boot/dts/zynq-7000.dtsi |  2 ++
>  arch/arm/boot/dts/zynq-zc702.dts |  6 +++++-
>  arch/arm/boot/dts/zynq-zc706.dts | 35 +++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/zynq-zed.dts   | 35 +++++++++++++++++++++++++++++++++++
>  arch/arm/mach-zynq/common.c      |  1 -
>  6 files changed, 80 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/boot/dts/zynq-zc706.dts
>  create mode 100644 arch/arm/boot/dts/zynq-zed.dts
> 
> -- 
> 1.8.3
> 
> 

Hi!

The series looks okay now:

	Reviewed-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
