Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbaCQJyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:54:51 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:38068 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbaCQJys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:54:48 -0400
Message-ID: <5326C66D.9030408@atmel.com>
Date: Mon, 17 Mar 2014 17:54:53 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, <nicolas.ferre@atmel.com>
CC: Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] ASoC: atmel: document clock properties of the wm8904
 driver
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com> <1395049541-28128-8-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1395049541-28128-8-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 05:45 PM, Bo Shen wrote:
> From: Boris BREZILLON <b.brezillon@overkiz.com>
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Oh, sorry for my SOB. Please remove it when apply.

> ---
>
>   Documentation/devicetree/bindings/sound/atmel-wm8904.txt | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt b/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
> index 8bbe50c..aca341c 100644
> --- a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
> +++ b/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
> @@ -3,6 +3,8 @@ Atmel ASoC driver with wm8904 audio codec complex
>   Required properties:
>     - compatible: "atmel,asoc-wm8904"
>     - atmel,model: The user-visible name of this sound complex.
> +  - clocks: A list of clocks needed by the wm8904 chip.
> +  - clock-output-names: Driver related clock names. Shall contain "pck0".
>     - atmel,audio-routing: A list of the connections between audio components.
>       Each entry is a pair of strings, the first being the connection's sink,
>       the second being the connection's source. Valid names for sources and
>

Best Regards,
Bo Shen
