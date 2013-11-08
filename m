Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab3KHOJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 09:09:30 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:41105 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab3KHOJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 09:09:29 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 1/2] dt: disable self-tests for !OF_IRQ
To: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: davem@davemloft.net, Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <1383848149-15488-1-git-send-email-robherring2@gmail.com>
References: <1383848149-15488-1-git-send-email-robherring2@gmail.com>
Date: Fri, 08 Nov 2013 14:09:23 +0000
Message-Id: <20131108140923.544A6C421A8@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Nov 2013 12:15:48 -0600, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Fix OF selftest compile on sparc which does not enable OF_IRQ.
> 
> drivers/of/selftest.c:177: undefined reference to `of_irq_parse_one'
> drivers/of/selftest.c:197: undefined reference to `of_irq_parse_one'
> drivers/of/selftest.c:248: undefined reference to `of_irq_parse_one'
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Acked-by: Grant Likely <grant.likely@linaro.org>

g.


> ---
>  drivers/of/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index 9d2009a..9b28f8b 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -17,6 +17,7 @@ config PROC_DEVICETREE
>  
>  config OF_SELFTEST
>  	bool "Device Tree Runtime self tests"
> +	depends on OF_IRQ
>  	help
>  	  This option builds in test cases for the device tree infrastructure
>  	  that are executed one at boot time, and the results dumped to the
> -- 
> 1.8.1.2
> 

