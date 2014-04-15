Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaDOKWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:22:15 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:64886 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753732AbaDOKWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:22:13 -0400
Message-ID: <1397557331.1985.36.camel@x220>
Subject: Re: [PATCH v2] spi: cadence: Add dependency on ARCH_ARM
From: Paul Bolle <pebolle@tiscali.nl>
To: Harini Katakam <harinik@xilinx.com>
Cc: broonie@kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, michals@xilinx.com
Date: Tue, 15 Apr 2014 12:22:11 +0200
In-Reply-To: <1397556735-2536-1-git-send-email-harinik@xilinx.com>
References: <1397556735-2536-1-git-send-email-harinik@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2014 10:22:11.0726 (UTC) FILETIME=[905A12E0:01CF5894]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 15:42 +0530, Harini Katakam wrote:
> Add dependency on ARCH_ARM in Kconfig.
> This is to fix the build error related to _relaxed IO.
> 
> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> ---
> 
> v2 changes:
> Dependency on ARCH_ARM instead of restricting to ARCH_ZYNQ.
> 
> ---
>  drivers/spi/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index b0f091b..32c27dd 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -150,6 +150,7 @@ config SPI_BUTTERFLY
>  
>  config SPI_CADENCE
>  	tristate "Cadence SPI controller"
> +	depends on ARCH_ARM

Did you mean just ARM?

>  	depends on SPI_MASTER
>  	help
>  	  This selects the Cadence SPI controller master driver


Paul Bolle

