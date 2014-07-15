Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbaGOPg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:36:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:58117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaGOPgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:36:55 -0400
Message-ID: <53C54A8F.8080909@infradead.org>
Date: Tue, 15 Jul 2014 08:36:47 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Samarth Parikh <samarthp@ymail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] Documentation: added missing semicolon in at25 dts example
References: <1405430449-21283-1-git-send-email-samarthp@ymail.com>
In-Reply-To: <1405430449-21283-1-git-send-email-samarthp@ymail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding dt bindings people + list]

On 07/15/14 06:20, Samarth Parikh wrote:
> Added a missing semicolon ";" in device tree structure
> example of "EEPROMs (SPI) compatible with Atmel at25" in
> documentation of device tree bindings.
> 
> Signed-off-by: Samarth Parikh <samarthp@ymail.com>
> ---
>  Documentation/devicetree/bindings/misc/at25.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/misc/at25.txt b/Documentation/devicetree/bindings/misc/at25.txt
> index 1d34471..cf830bd 100644
> --- a/Documentation/devicetree/bindings/misc/at25.txt
> +++ b/Documentation/devicetree/bindings/misc/at25.txt
> @@ -24,7 +24,7 @@ Additional compatible properties are also allowed.
>  Example:
>  	at25@0 {
>  		compatible = "atmel,at25", "st,m95256";
> -		reg = <0>
> +		reg = <0>;
>  		spi-max-frequency = <5000000>;
>  		spi-cpha;
>  		spi-cpol;
> 


-- 
~Randy
