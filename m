Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab3DSJiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:38:05 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:17452 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677Ab3DSJiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:38:03 -0400
Message-ID: <51711076.7000503@atmel.com>
Date: Fri, 19 Apr 2013 11:37:58 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Josh Wu <josh.wu@atmel.com>
Subject: Re: [PATCH] ARM: at91/sama5d34ek.dts: remove not needed compatibility
 string
References: <1366364129-15974-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1366364129-15974-1-git-send-email-nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 11:35 AM, Nicolas Ferre :
> "atmel,sama5ek" compatibility sting does not correspond to a
> useful board configuration. This d35ek.dts is the only sama5d3

s/d35/d34/

sorry.

> .dts file affected.
> 
> Reported-by: Josh Wu <josh.wu@atmel.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/boot/dts/sama5d34ek.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/sama5d34ek.dts b/arch/arm/boot/dts/sama5d34ek.dts
> index d2739f8..6bebfcd 100644
> --- a/arch/arm/boot/dts/sama5d34ek.dts
> +++ b/arch/arm/boot/dts/sama5d34ek.dts
> @@ -12,7 +12,7 @@
>  
>  / {
>  	model = "Atmel SAMA5D34-EK";
> -	compatible = "atmel,sama5d34ek", "atmel,sama5ek", "atmel,sama5d3xmb", "atmel,sama5d3xcm", "atmel,sama5d3", "atmel,sama5";
> +	compatible = "atmel,sama5d34ek", "atmel,sama5d3xmb", "atmel,sama5d3xcm", "atmel,sama5d3", "atmel,sama5";
>  
>  	ahb {
>  		apb {
> 


-- 
Nicolas Ferre
