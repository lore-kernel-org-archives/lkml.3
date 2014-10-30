Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321AbaJ3Ogc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:36:32 -0400
Received: from down.free-electrons.com ([37.187.137.238]:51365 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759506AbaJ3Og3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:36:29 -0400
Date: Thu, 30 Oct 2014 15:36:24 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: at91rm9200: allow building when using device
 tree
Message-ID: <20141030153624.6643c1b4@bbrezillon>
In-Reply-To: <1414678534-2677-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1414678534-2677-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014 15:15:34 +0100
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> When building with device tree, ARCH_AT91RM9200 may not be selected. Allow
> building that driver by also depending on ARCH_AT91.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  drivers/watchdog/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index e3d5bf0a5021..5445343ff2a1 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -144,7 +144,7 @@ config ARM_SP805_WATCHDOG
>  
>  config AT91RM9200_WATCHDOG
>  	tristate "AT91RM9200 watchdog"
> -	depends on ARCH_AT91RM9200
> +	depends on ARCH_AT91RM9200 || ARCH_AT91
>  	help
>  	  Watchdog timer embedded into AT91RM9200 chips. This will reboot your
>  	  system when the timeout is reached.



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
