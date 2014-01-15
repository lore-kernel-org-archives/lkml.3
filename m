Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaAORR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:17:28 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:10084 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaAORRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:17:25 -0500
Message-ID: <52D6C2A1.4080405@atmel.com>
Date: Wed, 15 Jan 2014 18:17:21 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, <broonie@kernel.org>,
        <devicetree@vger.kernel.org>
CC: <plagnioj@jcrosoft.com>, <linux-sound@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-arm-kernel@lists.infradead.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, "Mark Rutland" <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, "Mark Brown" <broonie@linaro.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Binding: atmel-wm8904: add option to choose clock
References: <1389669956-2304-1-git-send-email-voice.shen@atmel.com> <1389669956-2304-4-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1389669956-2304-4-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/2014 04:25, Bo Shen :
> Add the option to choose clock output on which pin connect to SSC.
> Default is on TK pin to SSC, add clk_from_rk_pin option, the clock

Please do not use "_" in DT properties. It is a common pattern to use
"-" instead.

> is on RK pin to SSC.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
> 
>  Documentation/devicetree/bindings/sound/atmel-wm8904.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt b/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
> index 8bbe50c..68a5c1a 100644
> --- a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
> +++ b/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
> @@ -33,6 +33,8 @@ Required properties:
>  
>  Optional properties:
>    - pinctrl-names, pinctrl-0: Please refer to pinctrl-bindings.txt
> +  - clk_from_rk_pin: according to hardware design, clk privide on rk pin

typo + more description is needed:
Please tell that it is a boolean property, that by default it is using
the TK pin (like in the commit message in fact).

Bye,

> +    to ssc device
>  
>  Example:
>  sound {
> 


-- 
Nicolas Ferre
