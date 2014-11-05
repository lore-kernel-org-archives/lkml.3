Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaKEIuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:50:50 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:59212 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaKEIut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:50:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Nov 2014 09:51:39 +0100
From: Stefan Agner <stefan@agner.ch>
To: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Cc: shawn.guo@freescale.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: vf-colibri-eval-v3.dts: Enable ST-M41T0M6
 RTC
In-Reply-To: <c7608ccea2f1c791a096fe630a2ac4dd8bb16b60.1415099486.git.bhuvanchandra.dv@toradex.com>
References: <cover.1415099486.git.bhuvanchandra.dv@toradex.com>
 <c7608ccea2f1c791a096fe630a2ac4dd8bb16b60.1415099486.git.bhuvanchandra.dv@toradex.com>
Message-ID: <a4c9562607b0c7e2c5d5a0fb06bfa663@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-11-04 12:22, schrieb Bhuvanchandra DV:
> ST-M41T0M6 is available on Colibri carrier boards.
> Hence enable M41T0M6 RTC.
> 
> Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
> ---
>  arch/arm/boot/dts/vf-colibri-eval-v3.dtsi |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
> b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
> index 0251e6c..f807b5b 100644
> --- a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
> +++ b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
> @@ -36,6 +36,12 @@
>  &i2c0 {
>  	clock-frequency = <400000>;
>  	status = "okay";
> +
> +	/* M41T0M6 real time clock on carrier board */
> +	rtc: m41t0m6@68 {
> +		compatible = "st,m41t00";
> +		reg = <0x68>;
> +	};
>  };
>  
>  &pwm0 {

Acked-by: Stefan Agner <stefan@agner.ch>
