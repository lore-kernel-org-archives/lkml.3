Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaFPLXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:23:25 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:41233 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbaFPLXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:23:22 -0400
Message-ID: <539ED3A5.5050300@gmail.com>
Date: Mon, 16 Jun 2014 13:23:17 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: berlin: enable i2c0 and i2c2
References: <1401780790-17830-1-git-send-email-antoine.tenart@free-electrons.com> <1401780790-17830-3-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1401780790-17830-3-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 09:33 AM, Antoine Ténart wrote:
> Enable the I2C0 and I2C2 for the Marvell Berlin BG2G DMP. I2C1 and I2C3
> are also working on this board, but no devices seemed to be there.
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>

Applied to berlin/dt with Andrew's Reviewed-by.

Thanks!

> ---
>   arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
> index 995150f93795..a357ce02a64e 100644
> --- a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
> +++ b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
> @@ -34,6 +34,14 @@
>   	status = "okay";
>   };
>
> +&i2c0 {
> +	status = "okay";
> +};
> +
> +&i2c2 {
> +	status = "okay";
> +};
> +
>   &uart0 {
>   	status = "okay";
>   };
>

