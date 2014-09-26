Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaIZLrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:47:08 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:62114 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753326AbaIZLrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:47:06 -0400
Message-ID: <1411732023.7866.15.camel@x220>
Subject: Re: [PATCHv3 2/7] ARM: at91: introduce basic SAMA5D4 support
From: Paul Bolle <pebolle@tiscali.nl>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 26 Sep 2014 13:47:03 +0200
In-Reply-To: <1410797759-18675-3-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410797759-18675-1-git-send-email-alexandre.belloni@free-electrons.com>
	 <1410797759-18675-3-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Sep 2014 11:47:03.0770 (UTC) FILETIME=[973153A0:01CFD97F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-15 at 18:15 +0200, Alexandre Belloni wrote:
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

This landed in next-20140926, as commit 2dc850b62e5b ("ARM: at91:
introduce basic SAMA5D4 support").

> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index b11ad54f8d17..7b44db208f10 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -101,6 +101,10 @@ choice
>  		bool "Kernel low-level debugging on 9263 and 9g45"
>  		depends on HAVE_AT91_DBGU1
>  
> +	config AT91_DEBUG_LL_DBGU2
> +		bool "Kernel low-level debugging on sama5d4"
> +		depends on HAVE_AT91_DBGU2
> +

Why is this Kconfig symbol needed? Nothing in next-20140926 uses it. Are
future users perhaps queued somewhere (say, in commits that didn't
survive today's rather lively linux-next merges)?

>  	config DEBUG_BCM2835
>  		bool "Kernel low-level debugging on BCM2835 PL011 UART"
>  		depends on ARCH_BCM2835


Paul Bolle

