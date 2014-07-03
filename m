Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbaGCPko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:40:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403AbaGCPkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:40:42 -0400
Message-ID: <53B57977.6010309@suse.de>
Date: Thu, 03 Jul 2014 17:40:39 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-samsung-soc@vger.kernel.org, linux-doc@vger.kernel.org
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Doug Anderson <dianders@chromium.org>, Simon Glass <sjg@chromium.org>,
        Mark Brown <broonie@linaro.org>, Michael Spang <spang@chromium.org>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Documentation: devicetree: Fix tps65090 typos in example
References: <1403737664-6426-1-git-send-email-afaerber@suse.de>
In-Reply-To: <1403737664-6426-1-git-send-email-afaerber@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.06.2014 01:07, schrieb Andreas Färber:
> Specification and existing device trees use vsys-l{1,2}-supply,
> not vsys_l{1,2}-supply. Fix the example to match the specification.
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v1 -> v2:
>  * More verbose commit message (requested by Mark Rutland)

Ping! Any issue remaining or maintainers/lists missing in CC?

Thanks,
Andreas

>  Documentation/devicetree/bindings/regulator/tps65090.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/regulator/tps65090.txt b/Documentation/devicetree/bindings/regulator/tps65090.txt
> index 34098023..ca69f5e 100644
> --- a/Documentation/devicetree/bindings/regulator/tps65090.txt
> +++ b/Documentation/devicetree/bindings/regulator/tps65090.txt
> @@ -45,8 +45,8 @@ Example:
>  		infet5-supply = <&some_reg>;
>  		infet6-supply = <&some_reg>;
>  		infet7-supply = <&some_reg>;
> -		vsys_l1-supply = <&some_reg>;
> -		vsys_l2-supply = <&some_reg>;
> +		vsys-l1-supply = <&some_reg>;
> +		vsys-l2-supply = <&some_reg>;
>  
>  		regulators {
>  			dcdc1 {

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
