Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaBJJV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:21:57 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:46863 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaBJJVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:21:51 -0500
Message-ID: <52F89A23.9040307@atmel.com>
Date: Mon, 10 Feb 2014 10:21:39 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, <broonie@kernel.org>
CC: <plagnioj@jcrosoft.com>, <linux-sound@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-arm-kernel@lists.infradead.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, "Mark Rutland" <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, "Mark Brown" <broonie@linaro.org>,
        Richard Genoud <richard.genoud@gmail.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] Binding: atmel-ssc: add option to choose clock
References: <1392012586-30790-1-git-send-email-voice.shen@atmel.com> <1392012586-30790-3-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1392012586-30790-3-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 07:09, Bo Shen :
> Add the option to choose clock on which pin input to SSC (as slave).
> Default is on TK pin to SSC, add "atmel,clk-from-rk-pin" option to
> specify the clock is on RK pin to SSC.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> Changes in v3:
>   - None
> Series-changes: 2
>   - using "-" replace "_" in binding document
> 
>  Documentation/devicetree/bindings/misc/atmel-ssc.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/misc/atmel-ssc.txt b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
> index a45ae08..5c1e14e 100644
> --- a/Documentation/devicetree/bindings/misc/atmel-ssc.txt
> +++ b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
> @@ -14,6 +14,14 @@ Required properties for devices compatible with "atmel,at91sam9g45-ssc":
>    See Documentation/devicetree/bindings/dma/atmel-dma.txt for details.
>  - dma-names: Must be "tx", "rx".
>  
> +Optional properties:
> +  - atmel,clk-from-rk-pin: bool property.
> +     - When SSC works in slave mode, according to the hardware design, the
> +       clock can get from TK pin, and also can get from RK pin. So, add
> +       this parameter to choose where the clock from.
> +     - By default the clock is from TK pin, if the clock from RK pin, this
> +       property is needed.
> +
>  Examples:
>  - PDC transfer:
>  ssc0: ssc@fffbc000 {
> 


-- 
Nicolas Ferre
