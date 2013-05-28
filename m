Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208Ab3E1V0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:26:23 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:61596 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933709Ab3E1V0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:26:09 -0400
Message-ID: <51A520ED.9070106@gmail.com>
Date: Tue, 28 May 2013 22:26:05 +0100
From: Jon Hunter <jgchunter@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Afzal Mohammed <afzal@ti.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>
Subject: Re: [PATCH v2 12/14] Documentation: dt: binding: omap: am43x counter
References: <cover.1369658705.git.afzal@ti.com> <755964dc45ae4f023540c05e5739fca87d0ea70b.1369658705.git.afzal@ti.com>
In-Reply-To: <755964dc45ae4f023540c05e5739fca87d0ea70b.1369658705.git.afzal@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 27/05/13 15:37, Afzal Mohammed wrote:
> AM43x 32K counter binding.
> 
> Signed-off-by: Afzal Mohammed <afzal@ti.com>
> ---
>  Documentation/devicetree/bindings/arm/omap/counter.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/omap/counter.txt b/Documentation/devicetree/bindings/arm/omap/counter.txt
> index 5bd8aa0..9c48dca 100644
> --- a/Documentation/devicetree/bindings/arm/omap/counter.txt
> +++ b/Documentation/devicetree/bindings/arm/omap/counter.txt
> @@ -2,6 +2,7 @@ OMAP Counter-32K bindings
>  
>  Required properties:
>  - compatible:	Must be "ti,omap-counter32k" for OMAP controllers
> +		"ti,am4372-counter32k","ti,omap-counter32k" for AM43x counter
>  - reg:		Contains timer register address range (base address and length)
>  - ti,hwmods:	Name of the hwmod associated to the counter, which is typically
>  		"counter_32k"

Changelog should state why this is needed.

Jon

