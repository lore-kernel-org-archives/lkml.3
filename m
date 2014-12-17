Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaLQRcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:32:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaLQRcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:32:19 -0500
Date: Wed, 17 Dec 2014 09:32:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: atull@opensource.altera.com
Cc: jgunthorpe@obsidianresearch.com, hpa@zytor.com, monstr@monstr.eu,
        michal.simek@xilinx.com, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        pantelis.antoniou@konsulko.com, robh+dt@kernel.org,
        grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, pavel@denx.de, broonie@kernel.org,
        philip@balister.org, rubini@gnudd.com, s.trumtrar@pengutronix.de,
        jason@lakedaemon.net, kyle.teske@ni.com, nico@linaro.org, balbi@ti.com,
        m.chehab@samsung.com, davidb@codeaurora.org, rob@landley.net,
        davem@davemloft.net, cesarb@cesarb.net, sameo@linux.intel.com,
        akpm@linux-foundation.org, linus.walleij@linaro.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devel@driverdev.osuosl.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v5 6/6] ARM: socfpga: defconfig: enable fpga manager
Message-ID: <20141217173216.GA24913@kroah.com>
References: <1418835289-15752-1-git-send-email-atull@opensource.altera.com>
 <1418835289-15752-7-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418835289-15752-7-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 10:54:49AM -0600, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Enable FPGA manager for Altera socfpga.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> ---
> v5: s/CONFIG_FPGA_MGR_ALTERA/CONFIG_FPGA_MGR_SOCFPGA/
> ---
>  arch/arm/configs/socfpga_defconfig |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/configs/socfpga_defconfig b/arch/arm/configs/socfpga_defconfig
> index a2956c3..f1d6a3b 100644
> --- a/arch/arm/configs/socfpga_defconfig
> +++ b/arch/arm/configs/socfpga_defconfig
> @@ -86,6 +86,10 @@ CONFIG_USB_DWC2=y
>  CONFIG_USB_DWC2_HOST=y
>  CONFIG_MMC=y
>  CONFIG_MMC_DW=y
> +CONFIG_STAGING=y
> +CONFIG_FPGA=y
> +CONFIG_FPGA_MGR_SYSFS=y
> +CONFIG_FPGA_MGR_SOCFPGA=y
>  CONFIG_EXT2_FS=y
>  CONFIG_EXT2_FS_XATTR=y
>  CONFIG_EXT2_FS_POSIX_ACL=y

Do defconfigs really matter anymore?
