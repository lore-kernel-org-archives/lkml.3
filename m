Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab3COVA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 17:00:26 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:54627 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab3COVAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 17:00:25 -0400
Message-ID: <51439A3C.1010505@cogentembedded.com>
Date: Sat, 16 Mar 2013 01:01:32 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux-arm-kernel@lists.infradead.org, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        kevin@allwinnertech.com, sunny@allwinnertech.com
Subject: Re: [PATCH 4/6] ARM: sunxi: dt: Add uart3 dt node
References: <1363377988-4966-1-git-send-email-maxime.ripard@free-electrons.com> <1363377988-4966-5-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1363377988-4966-5-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/15/2013 11:06 PM, Maxime Ripard wrote:

> Both A10 and A13 Allwinner SoCs have a Synopsys APB uart3 device
> available, so add it to the sunxi.dtsi file
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Acked-by: Emilio López <emilio@elopez.com.ar>
> ---
>   arch/arm/boot/dts/sunxi.dtsi |   10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sunxi.dtsi b/arch/arm/boot/dts/sunxi.dtsi
> index 4f78ef7..324da45 100644
> --- a/arch/arm/boot/dts/sunxi.dtsi
> +++ b/arch/arm/boot/dts/sunxi.dtsi
> @@ -68,5 +68,15 @@
>   			clocks = <&osc>;
>   			status = "disabled";
>   		};
> +
> +		uart3: uart@01c28c00 {

    IIRC, historically, the property name should be "serial", not "uart".

WBR, Sergei

