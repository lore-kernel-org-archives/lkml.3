Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbbA1UYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:24:00 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45593 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942AbbA1UX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:23:56 -0500
Message-ID: <54C90F89.1040500@linaro.org>
Date: Wed, 28 Jan 2015 16:34:17 +0000
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-mmc@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] mmc: pwrseq: Document that simple sequence support
 more than one GPIO
References: <1422439819-29854-1-git-send-email-javier.martinez@collabora.co.uk> <1422439819-29854-2-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1422439819-29854-2-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 28/01/15 10:10, Javier Martinez Canillas wrote:
> Many SDIO/MMC attached WLAN chips need more than one ping for their reset
> sequence. Extend the pwrseq_simple binding to support more than one pin.
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>   Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
> index da333d9ed94c..9a77deb164c7 100644
> --- a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
> +++ b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt
> @@ -8,9 +8,9 @@ Required properties:
>   - compatible : contains "mmc-pwrseq-simple".
>
>   Optional properties:
> -- reset-gpios : contains a GPIO specifier. The reset GPIO is asserted at
> -	initialization and prior we start the power up procedure of the card. It
> -	will be de-asserted right after the power has been provided to the card.
> +- reset-gpios : contains a list of GPIO specifiers. The reset GPIOs are asserted
> +	at initialization and prior we start the power up procedure of the card.
> +	Will be de-asserted right after the power has been provided to the card.
Makes sense if you add "They" before last sentence.
>
>   Example:
>
>
