Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaE0M01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 08:26:27 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:59319 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaE0M0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 08:26:25 -0400
Message-ID: <5384846D.1000305@atmel.com>
Date: Tue, 27 May 2014 14:26:21 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add AT91 Clock Support entry
References: <1401190768-3932-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1401190768-3932-1-git-send-email-boris.brezillon@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/05/2014 13:39, Boris BREZILLON :
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Of course Boris, that will be good:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  MAINTAINERS | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1066264..40c5580 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -808,6 +808,11 @@ F:	arch/arm/boot/dts/at91*.dtsi
>  F:	arch/arm/boot/dts/sama*.dts
>  F:	arch/arm/boot/dts/sama*.dtsi
>  
> +ARM/ATMEL AT91 Clock Support
> +M:	Boris Brezillon <boris.brezillon@free-electrons.com>
> +S:	Maintained
> +F:	drivers/clk/at91
> +
>  ARM/CALXEDA HIGHBANK ARCHITECTURE
>  M:	Rob Herring <robh@kernel.org>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> 


-- 
Nicolas Ferre
