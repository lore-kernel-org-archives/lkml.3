Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbaCYTNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:13:30 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:46060 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaCYTN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:13:28 -0400
Date: Tue, 25 Mar 2014 15:13:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-ide@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: limit sata_rcar host driver to ARCH_SHMOBILE
Message-ID: <20140325191324.GA3279@htj.dyndns.org>
References: <9835622.nRa3VdL61G@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9835622.nRa3VdL61G@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 08:10:27PM +0100, Bartlomiej Zolnierkiewicz wrote:
> Limit sata_rcar host driver to ARCH_SHMOBILE as Renesas R-Car SATA
> support is specific to Renesas SoCs and the driver to work requires
> suitable device tree node (or platform device) to be defined.
> 
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
>  drivers/ata/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: b/drivers/ata/Kconfig
> ===================================================================
> --- a/drivers/ata/Kconfig	2014-03-25 19:52:31.952327027 +0100
> +++ b/drivers/ata/Kconfig	2014-03-25 19:57:21.104322097 +0100
> @@ -298,6 +298,7 @@ config SATA_PROMISE
>  
>  config SATA_RCAR
>  	tristate "Renesas R-Car SATA support"
> +	depends on ARCH_SHMOBILE

COMPILE_TEST?

-- 
tejun
