Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbbAVMSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:18:30 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:45187 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbbAVMSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:18:24 -0500
Date: Thu, 22 Jan 2015 12:18:19 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kernel@stlinux.com, wsa@the-dreams.de, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/1] i2c: i2c-st: Rename clock reference to something
 that exists
Message-ID: <20150122121819.GC9129@x1>
References: <1409234523-20240-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409234523-20240-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram,

This patch has been on the list since forever.

I have Acks from the driver author, so I'm going to take this through
the MFD tree.  If you perk up later and decide to take it though the
I2C tree instead, let me know and I'll remove it from MFD.

> CLK_S_ICN_REG_0 hasn't existed for a while now.  This was renamed
> over a few commits, then finally removed in commit 5aa02b9 (ARM:
> STi: DT: STiH415: Remove unused CLK_S_ICN_REG_0 fixed clock).
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  Documentation/devicetree/bindings/i2c/i2c-st.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-st.txt b/Documentation/devicetree/bindings/i2c/i2c-st.txt
> index 437e0db..4c26fda 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c-st.txt
> +++ b/Documentation/devicetree/bindings/i2c/i2c-st.txt
> @@ -31,7 +31,7 @@ i2c0: i2c@fed40000 {
>  	compatible	= "st,comms-ssc4-i2c";
>  	reg		= <0xfed40000 0x110>;
>  	interrupts	=  <GIC_SPI 187 IRQ_TYPE_LEVEL_HIGH>;
> -	clocks		= <&CLK_S_ICN_REG_0>;
> +	clocks		= <&clk_s_a0_ls CLK_ICN_REG>;
>  	clock-names	= "ssc";
>  	clock-frequency = <400000>;
>  	pinctrl-names	= "default";

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
