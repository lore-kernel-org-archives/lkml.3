Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaJVHj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:39:29 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:47979 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaJVHj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:39:27 -0400
Message-ID: <54475F23.7050900@kapsi.fi>
Date: Wed, 22 Oct 2014 10:39:15 +0300
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>, linux-tegra@vger.kernel.org
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/12] of: Document long-ram-code property in nvidia,tegra20-apbmisc
References: <1413902788-7727-1-git-send-email-tomeu.vizoso@collabora.com> <1413902788-7727-3-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1413902788-7727-3-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 05:45 PM, Tomeu Vizoso wrote:
> Needed to properly decode the ram code register.
>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>   Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt b/Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt
> index b97b8be..e2562ed 100644
> --- a/Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt
> +++ b/Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt
> @@ -11,3 +11,6 @@ Required properties:
>          The second entry gives the physical address and length of the
>          registers indicating the strapping options.
>
> +Optional properties:
> +- nvidia,long-ram-code: boolean that tells whether the ram code is long (4 bit)
> +			or short (2 bit). If not present, false.
>

I think just "If present, the RAM code is long (4 bit). If not, short (2 
bit)" would be clearer, as the booleanness of this property is not 
really present in the device tree file.

