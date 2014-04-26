Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaDZQgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 12:36:36 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:40261 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaDZQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 12:36:34 -0400
Message-ID: <535BE096.2060407@cogentembedded.com>
Date: Sat, 26 Apr 2014 20:36:38 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] ARM: dts: DRA7: Add DT node for DES IP
References: <1398466968-29506-1-git-send-email-joelf@ti.com> <1398466968-29506-8-git-send-email-joelf@ti.com>
In-Reply-To: <1398466968-29506-8-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 26-04-2014 3:02, Joel Fernandes wrote:

> DRA7xx SoCs have a DES3DES IP. Add DT data for the same.

> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>   arch/arm/boot/dts/dra7.dtsi |   11 +++++++++++
>   1 file changed, 11 insertions(+)

> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index 1c0f8e1..0533b89 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -789,6 +789,17 @@
>   			dma-names = "tx0", "rx0";
>   			status = "disabled";
>   		};
> +
> +		des: des@480a5000 {

    Shouldn't the node name be "crypto@480a5000", according to the ePAPR standard?

WBR, Sergei

