Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3JaH3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 03:29:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45248 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3JaH3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 03:29:21 -0400
Date: Thu, 31 Oct 2013 08:29:07 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Nicolin Chen <b42378@freescale.com>
Cc: timur@tabi.org, shawn.guo@linaro.org, broonie@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, rob.herring@calxeda.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Subject: Re: [PATCH v2 1/4] dma: imx-sdma: Add sdma firmware version 2 support
Message-ID: <20131031072907.GG24559@pengutronix.de>
Mail-Followup-To: Nicolin Chen <b42378@freescale.com>, timur@tabi.org,
	shawn.guo@linaro.org, broonie@kernel.org,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	dmaengine@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	alsa-devel@alsa-project.org, rob.herring@calxeda.com,
	mark.rutland@arm.com, swarren@wwwdotorg.org, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org
References: <cover.1383197521.git.b42378@freescale.com>
 <cfe6edbff010aefc8a35df8a719b26bd238cb3cc.1383197521.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfe6edbff010aefc8a35df8a719b26bd238cb3cc.1383197521.git.b42378@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:26:43 up 67 days, 16:57, 52 users,  load average: 0.26, 0.08,
 0.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 02:32:03PM +0800, Nicolin Chen wrote:
> On i.MX5/6 series, SDMA is using new version firmware to support SSI
> dual FIFO feature and HDMI Audio (i.MX6Q/DL only). Thus add it.
> 
> Signed-off-by: Nicolin Chen <b42378@freescale.com>
> ---
> diff --git a/include/linux/platform_data/dma-imx-sdma.h b/include/linux/platform_data/dma-imx-sdma.h
> index 3a39428..14ca582 100644
> --- a/include/linux/platform_data/dma-imx-sdma.h
> +++ b/include/linux/platform_data/dma-imx-sdma.h
> @@ -43,6 +43,9 @@ struct sdma_script_start_addrs {
>  	s32 dptc_dvfs_addr;
>  	s32 utra_addr;
>  	s32 ram_code_start_addr;

You could add a comment here, like: /* End of v1 array */

Otherwise:

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> +	s32 mcu_2_ssish_addr;
> +	s32 ssish_2_mcu_addr;
> +	s32 hdmi_dma_addr;
>  };
>  
>  /**
> -- 
> 1.8.4
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
