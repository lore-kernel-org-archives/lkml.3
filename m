Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbaIYVqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 17:46:00 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53077 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbaIYVp5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 17:45:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Mark yao <mark.yao@rock-chips.com>, heiko@sntech.de,
        "Rob Herring" <robh+dt@kernel.org>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1410522327-23175-1-git-send-email-mark.yao@rock-chips.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        djkurtz@chromium.org, dianders@chromium.org, dkl@rock-chips.com,
        eddie.cai@rock-chips.com, xjq@rock-chips.com, kfx@rock-chips.com,
        huangtao@rock-chips.com, zyw@rock-chips.com, yxj@rock-chips.com,
        cym@rock-chips.com, zhengsq@rock-chips.com, caesar.wang@rock-chips.com,
        kever.yang@rock-chips.com, "Mark yao" <mark.yao@rock-chips.com>
References: <1410522327-23175-1-git-send-email-mark.yao@rock-chips.com>
Message-ID: <20140925214534.19023.78482@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: rockchip: rk3288: add reset indices for SOFTRST9-11
Date: Thu, 25 Sep 2014 14:45:34 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mark yao (2014-09-12 04:45:27)
> The patch add the rest of the indices of the additional reset
> registers from the updated TRM.
> 
> Signed-off-by: Mark yao <mark.yao@rock-chips.com>

Applied to clk-next.

Regards,
Mike

> ---
>  include/dt-bindings/clock/rk3288-cru.h | 43 ++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
> index ebcb460..e65d522 100644
> --- a/include/dt-bindings/clock/rk3288-cru.h
> +++ b/include/dt-bindings/clock/rk3288-cru.h
> @@ -276,3 +276,46 @@
>  #define SRST_USBHOST1_CON      140
>  #define SRST_USB_ADP           141
>  #define SRST_ACC_EFUSE         142
> +
> +#define SRST_CORESIGHT         144
> +#define SRST_PD_CORE_AHB_NOC   145
> +#define SRST_PD_CORE_APB_NOC   146
> +#define SRST_PD_CORE_MP_AXI    147
> +#define SRST_GIC               148
> +#define SRST_LCDC_PWM0         149
> +#define SRST_LCDC_PWM1         150
> +#define SRST_VIO0_H2P_BRG      151
> +#define SRST_VIO1_H2P_BRG      152
> +#define SRST_RGA_H2P_BRG       153
> +#define SRST_HEVC              154
> +#define SRST_TSADC             159
> +
> +#define SRST_DDRPHY0           160
> +#define SRST_DDRPHY0_APB       161
> +#define SRST_DDRCTRL0          162
> +#define SRST_DDRCTRL0_APB      163
> +#define SRST_DDRPHY0_CTRL      164
> +#define SRST_DDRPHY1           165
> +#define SRST_DDRPHY1_APB       166
> +#define SRST_DDRCTRL1          167
> +#define SRST_DDRCTRL1_APB      168
> +#define SRST_DDRPHY1_CTRL      169
> +#define SRST_DDRMSCH0          170
> +#define SRST_DDRMSCH1          171
> +#define SRST_CRYPTO            174
> +#define SRST_C2C_HOST          175
> +
> +#define SRST_LCDC1_AXI         176
> +#define SRST_LCDC1_AHB         177
> +#define SRST_LCDC1_DCLK                178
> +#define SRST_UART0             179
> +#define SRST_UART1             180
> +#define SRST_UART2             181
> +#define SRST_UART3             182
> +#define SRST_UART4             183
> +#define SRST_SIMC              186
> +#define SRST_PS2C              187
> +#define SRST_TSP               188
> +#define SRST_TSP_CLKIN0                189
> +#define SRST_TSP_CLKIN1                190
> +#define SRST_TSP_27M           191
> -- 
> 1.9.1
> 
