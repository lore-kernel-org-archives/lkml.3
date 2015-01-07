Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbbAGOW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:22:56 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:64506 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbAGOWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:22:54 -0500
Message-ID: <54AD413A.8030208@gmail.com>
Date: Wed, 07 Jan 2015 15:22:50 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
To: Jisheng Zhang <jszhang@marvell.com>, mturquette@linaro.org,
        sboyd@codeaurora.org, alexandre.belloni@free-electrons.com,
        antoine.tenart@free-electrons.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: berlin: add broken-cd and set bus width for
 eMMC in Marvell DMP DT
References: <1420016272-6789-1-git-send-email-jszhang@marvell.com> <1420016272-6789-3-git-send-email-jszhang@marvell.com>
In-Reply-To: <1420016272-6789-3-git-send-email-jszhang@marvell.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.12.2014 09:57, Jisheng Zhang wrote:
> There's no card detection for the eMMC, so this patch adds the missing
> broken-cd property. This patch also sets bus width as 8 to add
> MMC_CAP_8_BIT_DATA in the Host capabilities.
>
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> Cc: stable@vger.kernel.org # 3.16+

Applied to berlin/fixes.

Thanks!

> ---
>   arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
> index 28e7e20..a98ac1b 100644
> --- a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
> +++ b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
> @@ -65,6 +65,8 @@
>   };
>
>   &sdhci2 {
> +	broken-cd;
> +	bus-width = <8>;
>   	non-removable;
>   	status = "okay";
>   };
>

