Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbaE1B1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 21:27:19 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55126 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbaE1B1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 21:27:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Nicolas Ferre" <nicolas.ferre@atmel.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1401190768-3932-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Boris BREZILLON" <boris.brezillon@free-electrons.com>
References: <1401190768-3932-1-git-send-email-boris.brezillon@free-electrons.com>
Message-ID: <20140528012708.7816.58824@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] MAINTAINERS: add AT91 Clock Support entry
Date: Tue, 27 May 2014 18:27:08 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Boris BREZILLON (2014-05-27 04:39:28)
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Applied to clk-next.

Regards,
Mike

> ---
>  MAINTAINERS | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1066264..40c5580 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -808,6 +808,11 @@ F: arch/arm/boot/dts/at91*.dtsi
>  F:     arch/arm/boot/dts/sama*.dts
>  F:     arch/arm/boot/dts/sama*.dtsi
>  
> +ARM/ATMEL AT91 Clock Support
> +M:     Boris Brezillon <boris.brezillon@free-electrons.com>
> +S:     Maintained
> +F:     drivers/clk/at91
> +
>  ARM/CALXEDA HIGHBANK ARCHITECTURE
>  M:     Rob Herring <robh@kernel.org>
>  L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> -- 
> 1.8.3.2
> 
