Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbaLPNqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 08:46:36 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:38125 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaLPNqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 08:46:35 -0500
Message-ID: <549037B8.6060803@cogentembedded.com>
Date: Tue, 16 Dec 2014 16:46:32 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Evgeni Dobrev <evgeni@studio-punkt.com>, devicetree@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: dts: kirkwood: enable phy driver for SATA controller
 on 88f6192
References: <20141215203724.GA22936@anne>
In-Reply-To: <20141215203724.GA22936@anne>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/15/2014 11:37 PM, Evgeni Dobrev wrote:

> This patch enables the phy drivers for the SATA controller on Marvell's 88f6192. Without them it is not possible to use SATA drives attached to this processor.

    Please wrap the change log likes at 80 characters or less.

> Signed-off-by: Evgeni Dobrev <evgeni@studio-punkt.com>
> ---
>   arch/arm/boot/dts/kirkwood-6192.dtsi |    2 ++
>   1 file changed, 2 insertions(+)

> diff --git a/arch/arm/boot/dts/kirkwood-6192.dtsi b/arch/arm/boot/dts/kirkwood-6192.dtsi
> index dd81508..bed2dec 100644
> --- a/arch/arm/boot/dts/kirkwood-6192.dtsi
> +++ b/arch/arm/boot/dts/kirkwood-6192.dtsi
> @@ -66,6 +66,8 @@
>   			interrupts = <21>;
>   			clocks = <&gate_clk 14>, <&gate_clk 15>;
>   			clock-names = "0", "1";
> +                        phys = <&sata_phy0>, <&sata_phy1>;
> +                        phy-names = "port0", "port1";

    Please indent with tabs,  not spaces.

[...]

WBR, Sergei

