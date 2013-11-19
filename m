Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab3KSFPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:15:30 -0500
Received: from mail.active-venture.com ([67.228.131.205]:49374 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab3KSFPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:15:25 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <528AF3EA.4070103@roeck-us.net>
Date: Mon, 18 Nov 2013 21:15:22 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Wim Van Sebroeck <wim@iguana.be>, Sekhar Nori <nsekhar@ti.com>,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Strashko Grygorii <grygorii.strashko@ti.com>
Subject: Re: [PATCH 4/6] watchdog: davinci: add "timeout-sec" property
References: <1384795139-19466-1-git-send-email-ivan.khoronzhuk@ti.com> <1384795139-19466-5-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384795139-19466-5-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 09:18 AM, Ivan Khoronzhuk wrote:
> Since Davinci WDT has been switched to use WDT core, it became able
> to support timeout-sec property, so add it to it's binding description.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   .../devicetree/bindings/watchdog/davinci-wdt.txt   |    4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt b/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
> index 75558cc..e450134 100644
> --- a/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
> +++ b/Documentation/devicetree/bindings/watchdog/davinci-wdt.txt
> @@ -4,9 +4,13 @@ Required properties:
>   - compatible : Should be "ti,davinci-wdt"
>   - reg : Should contain WDT registers location and length
>
> +Optional properties:
> +- timeout-sec : Contains the watchdog timeout in seconds
> +
>   Examples:
>
>   wdt: wdt@2320000 {
>   	compatible = "ti,davinci-wdt";
>   	reg = <0x02320000 0x80>;
> +	timeout-sec = <30>;
>   };
>

