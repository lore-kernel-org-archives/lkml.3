Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbaCEVai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:30:38 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:54328 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184AbaCEVae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:30:34 -0500
Message-ID: <5317A58C.1080703@cogentembedded.com>
Date: Thu, 06 Mar 2014 01:30:36 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        dinguyen@altera.com
Subject: Re: [PATCH] dts: add support for MMC on socfpga boards
References: <20140305162350.GA3674@pollux.denx.de>
In-Reply-To: <20140305162350.GA3674@pollux.denx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/05/2014 07:23 PM, Pavel Machek wrote:

> Add DTS binding for MMC on socfpga boards. Tested on Sockit.

> Signed-off-by: Pavel Machek <pavel@denx.de>

> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> index 537f1a5..cad7526 100644
> --- a/arch/arm/boot/dts/socfpga.dtsi
> +++ b/arch/arm/boot/dts/socfpga.dtsi
> @@ -521,6 +521,23 @@
>   			reg-io-width = <4>;
>   		};
>
> +		mmc: dwmmc0@ff704000 {

    ePAPR standard [1] tells us in section 2.2.2:

The name of a node should be somewhat generic, reflecting the function of the 
device and not its 3 precise programming model.

     So, please name the node just "mmc@ff704000". You can choose whatever 
label you like.

[1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf

WBR, Sergei

