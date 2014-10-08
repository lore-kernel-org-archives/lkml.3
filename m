Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbaJHNc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:32:28 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:65248 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbaJHNc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:32:27 -0400
Message-ID: <54353CE5.5070808@gmail.com>
Date: Wed, 08 Oct 2014 08:32:21 -0500
From: Dinh Nguyen <dinh.linux@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
CC: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuge <shuge@allwinnertech.com>,
        Meng Zhang <kevin@allwinnertech.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v3 3/5] ARM: dts: sun9i: Add A80 Optimus Board support
References: <1412773376-25212-1-git-send-email-wens@csie.org> <1412773376-25212-4-git-send-email-wens@csie.org>
In-Reply-To: <1412773376-25212-4-git-send-email-wens@csie.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/8/14, 8:02 AM, Chen-Yu Tsai wrote:
> The A80 Optimus Board is was launched with the Allwinner A80 SoC.
> It was jointly developed by Allwinner and Merrii.
> 
> This board has a UART port, a JTAG connector, USB host ports, a USB
> 3.0 OTG connector, an HDMI output, a micro SD slot, 8G NAND flash,
> 4G DRAM, a camera sensor interface, a WiFi/BT combo chip, a headphone
> jack, IR receiver, and additional GPIO headers.
> 
> This patch adds only basic support.
> 
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/boot/dts/Makefile              |  2 +
>  arch/arm/boot/dts/sun9i-a80-optimus.dts | 66 +++++++++++++++++++++++++++++++++
>  2 files changed, 68 insertions(+)
>  create mode 100644 arch/arm/boot/dts/sun9i-a80-optimus.dts
> 
[...]
> +
> +/dts-v1/;
> +/include/ "sun9i-a80.dtsi"
> +
> +/ {
> +	model = "Merrii A80 Optimus Board";
> +	compatible = "merrii,a80-optimus", "allwinner,sun9i-a80";

"merrii" should be added to vendor-prefixes.txt

Dinh
