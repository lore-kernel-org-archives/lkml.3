Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161737AbaKNSrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:47:17 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:59231 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161282AbaKNSrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:47:15 -0500
Message-ID: <54664E2F.6070701@cogentembedded.com>
Date: Fri, 14 Nov 2014 21:47:11 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com,
        balbi@ti.com, p.zabel@pengutronix.de
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 11/13] ARM: dts: Berlin: enable USB on the BG2Q DMP
References: <1415978763-27345-1-git-send-email-antoine.tenart@free-electrons.com> <1415978763-27345-12-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1415978763-27345-12-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11/14/2014 06:26 PM, Antoine Tenart wrote:

> Enable the 2 available USB PHY and USB nodes on the Marvell Berlin BG2Q
> DMP.

> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>   arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 53 ++++++++++++++++++++++++++++++
>   1 file changed, 53 insertions(+)

> diff --git a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
> index ea1f99b8eed6..f7c25580e122 100644
> --- a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
> +++ b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
[...]
> @@ -21,6 +23,39 @@
>   	choosen {
>   		bootargs = "console=ttyS0,115200 earlyprintk";
>   	};
> +
> +	regulators {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		reg_usb0_vbus: regulator@0 {

    Erm, I'm not seeing the "reg" prop. The <unit-address> part of the name 
shouldn't be used without the "reg" prop.

[...]

WBR, Sergei

