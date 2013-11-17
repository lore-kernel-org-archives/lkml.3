Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3KQC0B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 21:26:01 -0500
Received: from mail.active-venture.com ([67.228.131.205]:57441 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3KQCZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 21:25:53 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52882930.8020207@roeck-us.net>
Date: Sat, 16 Nov 2013 18:25:52 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, wim@iguana.be,
        nsekhar@ti.com, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org
CC: grant.likely@linaro.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, galak@kernel.crashing.org,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Fwd: [PATCH 5/8] watchdog: davinci: add "timeout-sec" property
References: <1383680783-12114-6-git-send-email-ivan.khoronzhuk@ti.com> <527A28D8.9040901@ti.com>
In-Reply-To: <527A28D8.9040901@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 03:32 AM, ivan.khoronzhuk wrote:
> Since Davinci WDT has been switched to use WDT core, it became able
> to support timeout-sec property, so add it to it's binding description.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>   .../devicetree/bindings/watchdog/davinci-wdt.txt   |    5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt b/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
> index 75558cc..1668b6e 100644
> --- a/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
> +++ b/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
> @@ -4,9 +4,14 @@ Required properties:
>   - compatible : Should be "ti,davinci-wdt"
>   - reg : Should contain WDT registers location and length
>
> +Optional properties:
> +

empty line not needed here (and inconsistent).

> +- timeout-sec:		Contains the watchdog timeout in seconds
> +

Formatting is different to other bindings.

>   Examples:
>
>   wdt: wdt@2320000 {
>   	compatible = "ti,davinci-wdt";
>   	reg = <0x02320000 0x80>;
> +	timeout-sec = <30>;
>   };
>

