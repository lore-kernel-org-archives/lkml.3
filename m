Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935113AbaGRR13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:27:29 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:61064 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934708AbaGRR11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:27:27 -0400
Message-ID: <53C95900.9050200@cogentembedded.com>
Date: Fri, 18 Jul 2014 21:27:28 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 2/8] Documentation: bindings: add the Berlin SATA
 PHY
References: <1405686607-8126-1-git-send-email-antoine.tenart@free-electrons.com> <1405686607-8126-3-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1405686607-8126-3-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/18/2014 04:30 PM, Antoine Ténart wrote:

> The Berlin SATA PHY drives the PHY related to the SATA interface. Add
> the corresponding documentation.

> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>   .../devicetree/bindings/phy/berlin-sata-phy.txt    | 34 ++++++++++++++++++++++
>   1 file changed, 34 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/phy/berlin-sata-phy.txt

> diff --git a/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt b/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
> new file mode 100644
> index 000000000000..88f8c23384c0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
> @@ -0,0 +1,34 @@
> +Berlin SATA PHY
> +---------------
> +
> +Required properties:
> +- compatible: should be "marvell,berlin2q-sata-phy"
> +- address-cells: should be 1
> +- size-cells: should be 0
> +- phy-cells: from the generic PHY bindings, must be 1

    It's "#address-cells", "#size-cells", and "#phy-cells".

> +- reg: address and length of the register
> +- clocks: reference to the clock entry
> +
> +Sub-nodes:
> +Each PHY should be represented as a sub-node.

    Then "#phy-cells" should also belong to the sub-nodes.

> +
> +Sub-nodes required properties:
> +- reg: the PHY number

WBR, Sergei

