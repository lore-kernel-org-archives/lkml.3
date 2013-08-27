Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3H0H7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 03:59:43 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:56410 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab3H0H7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 03:59:42 -0400
Message-ID: <521C5C85.2060007@atmel.com>
Date: Tue, 27 Aug 2013 10:00:05 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] ARM: at91/dt: define phy available on sama5d3
 mother board
References: <1377589007-3684-1-git-send-email-b.brezillon@overkiz.com> <1377589142-3758-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1377589142-3758-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/2013 09:39, Boris BREZILLON :
> This patch describe the phy used on atmel sama5d3 mother board:
>   - phy address
>   - phy interrupt pin
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   arch/arm/boot/dts/sama5d3xmb.dtsi |    8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
> index 8a9e05d..dba739b 100644
> --- a/arch/arm/boot/dts/sama5d3xmb.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
> @@ -81,6 +81,14 @@
>
>   			macb1: ethernet@f802c000 {
>   				phy-mode = "rmii";
> +
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				phy0: ethernet-phy@1 {
> +					interrupt-parent = <&pioE>;
> +					interrupts = <30 IRQ_TYPE_EDGE_FALLING>;
> +					reg = <1>;
> +				};
>   			};
>
>   			pinctrl@fffff200 {
>


-- 
Nicolas Ferre
