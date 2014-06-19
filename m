Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035AbaFSQb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:31:56 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:58697 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716AbaFSQby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:31:54 -0400
Message-ID: <53A31080.40707@cogentembedded.com>
Date: Thu, 19 Jun 2014 20:32:00 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: mvebu: Fix missing binding documentation for Armada
 38x
References: <1403186871-28204-1-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1403186871-28204-1-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 06:07 PM, Gregory CLEMENT wrote:

> For the Armada 380 and Armada 385 SoCs, the common bindings for those
> 2 SoCs, was forgotten. This patch add the documentation for the
> marvell,aramda38x property.

> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
> Hi,

> This fix should be merged in 3.16. For 3.15 I am not sure as it is not
> a regression.

> Thanks,
> Gregory

>   Documentation/devicetree/bindings/arm/armada-38x.txt | 4 ++++
>   1 file changed, 4 insertions(+)

> diff --git a/Documentation/devicetree/bindings/arm/armada-38x.txt b/Documentation/devicetree/bindings/arm/armada-38x.txt
> index 11f2330a6554..b68bcb80d2de 100644
> --- a/Documentation/devicetree/bindings/arm/armada-38x.txt
> +++ b/Documentation/devicetree/bindings/arm/armada-38x.txt
> @@ -6,5 +6,9 @@ following property:
>
>   Required root node property:
>
> +compatible: must contain "marvell,armada38x"
> +
> +Required root node property:

    Duplicate statement with the above?

> +
>    - compatible: must contain either "marvell,armada380" or
>      "marvell,armada385" depending on the variant of the SoC being used.

WBR, Sergei

