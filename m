Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030514Ab3DSNzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 09:55:09 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:61782 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030413Ab3DSNzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 09:55:07 -0400
Message-ID: <51714C74.2030907@cogentembedded.com>
Date: Fri, 19 Apr 2013 17:53:56 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: linux-arm-kernel@lists.infradead.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, tanzilli@acmesystems.it,
        dgilbert@interlog.com, robertcnelson@gmail.com
Subject: Re: [PATCH 1/5] ARM: at91: at91sam9x5 RTC is not compatible with
 at91rm9200 one
References: <cover.1366289869.git.nicolas.ferre@atmel.com> <864f10566b35864d469f6ff2913b9afaa0c69350.1366289869.git.nicolas.ferre@atmel.com>
In-Reply-To: <864f10566b35864d469f6ff2913b9afaa0c69350.1366289869.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 18-04-2013 17:01, Nicolas Ferre wrote:

> Due to a bug with RTC IMR, we cannot consider at91sam9x5 RTC compatible
> with the previous one. Modify DT compatibility string, even if the driver
> is not yet modified to take it into account.

> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>   arch/arm/boot/dts/at91sam9x5.dtsi | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
> index a3d4464..58747f3 100644
> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> @@ -564,7 +564,7 @@
>   			};
>
>   			rtc@fffffeb0 {
> -				compatible = "atmel,at91rm9200-rtc";
> +				compatible = "atmel,at91sam9x5-rtc";

    Do not use wildcards in the "compatible" prop values (I guess 'x' is a 
wildcard).

WBR, Sergei

