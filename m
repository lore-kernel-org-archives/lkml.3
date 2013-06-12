Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab3FLSYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:24:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55693 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab3FLSX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:23:59 -0400
Date: Wed, 12 Jun 2013 20:23:45 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dinh Nguyen <dinguyen@altera.com>, Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v2 3/3] arm: dt: zynq: Add support for the zed platform
Message-ID: <20130612182345.GA1656@pengutronix.de>
References: <1371055268-32337-1-git-send-email-soren.brinkmann@xilinx.com>
 <1371055268-32337-4-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371055268-32337-4-git-send-email-soren.brinkmann@xilinx.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:10:41 up 354 days,  9:22, 70 users,  load average: 0,43, 0,63,
 0,68
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 09:41:08AM -0700, Soren Brinkmann wrote:
> Add a DT fragment for the Zed Zynq platform and a corresponding
> target to the Makefile
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> I used the 'xlnx,...' compat strings since it seems this is what is
> used in the Xilinx and Digilent vendor trees.
> 
> +/include/ "zynq-7000.dtsi"
> +
> +/ {
> +	model = "Zynq Zed Development Board";
> +	compatible = "xlnx,zynq-zed", "xlnx,zynq-7000";
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0 0x20000000>;
> +	};
> +
> +	chosen {
> +		bootargs = "console=ttyPS1,115200 earlyprintk";
> +	};
> +
> +};

Hi!

This looks a little bit to basic. No?! Not even an UART?
The compatible should include digilent or avnet. Digilent only sells to academic
customers, Avnet doesn't.
I personally don't care what they do out of tree.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
