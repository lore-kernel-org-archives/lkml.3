Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3H0O5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:57:10 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:18659 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3H0O5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:57:08 -0400
Message-ID: <521CBE58.9060402@atmel.com>
Date: Tue, 27 Aug 2013 16:57:28 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: at91/at91-pinctrl documentation: add missing sam9x5
 compatible string
References: <1377609965-22154-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1377609965-22154-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/2013 15:26, Boris BREZILLON :
> Add missing "atmel,at91sam9x5-pinctrl" compatible string to the
> documentation.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   .../bindings/pinctrl/atmel,at91-pinctrl.txt        |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
> index 648d60e..cf7c7bc 100644
> --- a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
> @@ -18,7 +18,7 @@ mode) this pin can work on and the 'config' configures various pad settings
>   such as pull-up, multi drive, etc.
>
>   Required properties for iomux controller:
> -- compatible: "atmel,at91rm9200-pinctrl"
> +- compatible: "atmel,at91rm9200-pinctrl" or "atmel,at91sam9x5-pinctrl"
>   - atmel,mux-mask: array of mask (periph per bank) to describe if a pin can be
>     configured in this periph mode. All the periph and bank need to be describe.
>
>


-- 
Nicolas Ferre
