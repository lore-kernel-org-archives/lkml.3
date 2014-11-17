Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaKQS0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:26:45 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:54834 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaKQS0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:26:43 -0500
Message-ID: <546A3DD1.8020209@cogentembedded.com>
Date: Mon, 17 Nov 2014 21:26:25 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com,
        balbi@ti.com, p.zabel@pengutronix.de
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 10/13] ARM: dts: berlin: add BG2Q nodes for USB support
References: <1416231347-27193-1-git-send-email-antoine.tenart@free-electrons.com> <1416231347-27193-11-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1416231347-27193-11-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11/17/2014 04:35 PM, Antoine Tenart wrote:

> Adds nodes describing the Marvell Berlin BG2Q USB PHY and USB. The BG2Q
> SoC has 3 USB host controller, compatible with ChipIdea.

> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>   arch/arm/boot/dts/berlin2q.dtsi | 55 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 55 insertions(+)

> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> index 2de8d6f8973c..834142bdfbb1 100644
> --- a/arch/arm/boot/dts/berlin2q.dtsi
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
[...]
> @@ -457,5 +511,6 @@
>   				interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
>   			};
>   		};
> +

    Random whitespace change?

>   	};
>   };
>

WBR, Sergei

