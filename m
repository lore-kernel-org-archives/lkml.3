Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab3GKKnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:43:40 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:43522 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab3GKKne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:43:34 -0400
Date: Thu, 11 Jul 2013 11:43:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: J Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, grant.likely@secretlab.ca, broonie@kernel.org,
        ldewangan@nvidia.com, sameo@linux.intel.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, gg@slimlogic.co.uk
Subject: Re: [PATCH 1/4] MFD: Add TPS659038 documentation under Palmas
Message-ID: <20130711104327.GE25601@gmail.com>
References: <1371726289-10042-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1371726289-10042-1-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, J Keerthy wrote:

> Add TPS659038 documentation under Palmas.
> 
> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  Documentation/devicetree/bindings/mfd/palmas.txt |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
> index 7bcd59c..89cb773 100644
> --- a/Documentation/devicetree/bindings/mfd/palmas.txt
> +++ b/Documentation/devicetree/bindings/mfd/palmas.txt
> @@ -5,6 +5,7 @@ twl6035 (palmas)
>  twl6037 (palmas)
>  tps65913 (palmas)
>  tps65914 (palmas)
> +tps659038
>  
>  Required properties:
>  - compatible : Should be from the list
> @@ -14,6 +15,7 @@ Required properties:
>    ti,tps65913
>    ti,tps65914
>    ti,tps80036
> +  ti,tps659038
>  and also the generic series names
>    ti,palmas
>  - interrupt-controller : palmas has its own internal IRQs

Applied.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
