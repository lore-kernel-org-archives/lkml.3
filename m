Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaKJKIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:08:47 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:48673 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaKJKIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:08:46 -0500
Date: Mon, 10 Nov 2014 10:08:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 08/13] ARM: STi: DT: STiH410: Add defines for STiH410 DT
 clocks
Message-ID: <20141110100840.GO21424@x1>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
 <1415361475-6218-9-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415361475-6218-9-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014, Peter Griffin wrote:

> Although most clock outputs are the same as stih407 SoC, stih410
> also has some additional new clock outputs.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  include/dt-bindings/clock/stih410-clks.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>  create mode 100644 include/dt-bindings/clock/stih410-clks.h
> 
> diff --git a/include/dt-bindings/clock/stih410-clks.h b/include/dt-bindings/clock/stih410-clks.h
> new file mode 100644
> index 0000000..2c5d6ff
> --- /dev/null
> +++ b/include/dt-bindings/clock/stih410-clks.h
> @@ -0,0 +1,24 @@
> +/*
> + * This header provides constants clk index STMicroelectronics
> + * STiH410 SoC.
> + */
> +#ifndef _DT_BINDINGS_CLK_STIH410
> +#define _DT_BINDINGS_CLK_STIH410
> +#include "stih407-clks.h"

Nit: Please add a newline between the sentries and #include.

Apart from that, looks good:

Acked-by: Lee Jones <lee.jones@linaro.org>

> +/* STiH410 introduces new clock outputs compared to STiH407 */
> +
> +/* CLOCKGEN C0 */
> +#define CLK_TX_ICN_HADES	32
> +#define CLK_RX_ICN_HADES	33
> +#define CLK_ICN_REG_16		34
> +#define CLK_PP_HADES		35
> +#define CLK_CLUST_HADES		36
> +#define CLK_HWPE_HADES		37
> +#define CLK_FC_HADES		38
> +
> +/* CLOCKGEN D0 */
> +#define CLK_PCMR10_MASTER	4
> +#define CLK_USB2_PHY		5
> +
> +#endif

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
