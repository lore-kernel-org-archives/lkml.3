Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaCLE75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 00:59:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46176 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaCLE7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 00:59:55 -0400
Message-ID: <531FE9AD.7050703@ti.com>
Date: Wed, 12 Mar 2014 10:29:25 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
CC: <balbi@ti.com>, <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <tony@atomide.com>, <anatol.pomozov@gmail.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH v3 0/5] Add USB nodes for am43xx epos and gp evm
References: <1394193422-18242-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1394193422-18242-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 3/7/2014 5:26 PM, George Cherian wrote:
> The patch series adds USB dt nodes for am43xx epos and gp evm
>
> Boot tested with  Benoit's for_3.15 + following patches
>
> https://patchwork.kernel.org/patch/3600821/
> https://patchwork.kernel.org/patch/3600831/
> https://patchwork.kernel.org/patch/3600851/
> https://patchwork.kernel.org/patch/3600841/
>
>
> Changes from v1 -> v2
> 	* Reorder "doc: Add "ti,am437x-dwc3" comaptible for dwc3 glue"
> 	* Address v1 coments on "ARM: dts: AM4372: Add USB nodes"
>
> Changes from v2 -> v3
> 	* Removed unwanted dwc3_1 and dwc3_2 nodes from am437x-gp-evm.dts
> 	  and am43x-epos-evm.dts
>
> George Cherian (5):
>    doc: Add "ti,am437x-dwc3" comaptible for dwc3 glue
>    ARM: dts: am43xx clock data
>    ARM: dts: AM4372: Add USB nodes
>    ARM: dts: am437x-gp-evm: Enable USB
>    ARM: dts: am43x-epos-evm: Enable USB
>
>   Documentation/devicetree/bindings/usb/omap-usb.txt |  4 +-
>   arch/arm/boot/dts/am4372.dtsi                      | 95 ++++++++++++++++++++++
>   arch/arm/boot/dts/am437x-gp-evm.dts                | 18 ++++
>   arch/arm/boot/dts/am43x-epos-evm.dts               | 18 ++++
>   arch/arm/boot/dts/am43xx-clocks.dtsi               | 17 ++++
>   5 files changed, 151 insertions(+), 1 deletion(-)
Can you please take this series.
The whole series Reviewed-by: Roger Quadros <rogerq@ti.com>


-- 
-George

