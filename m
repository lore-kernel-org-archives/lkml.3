Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaGGKv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:51:57 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:48016 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaGGKvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:51:55 -0400
Date: Mon, 7 Jul 2014 11:51:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        peppe.cavallaro@st.com
Subject: Re: [PATCH v2 3/3] MAINTAINERS: Add dwc3-st.c file to ARCH/STI
 architecture
Message-ID: <20140707105149.GE6407@lee--X1>
References: <1404541530-27856-1-git-send-email-peter.griffin@linaro.org>
 <1404541530-27856-4-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404541530-27856-4-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Jul 2014, Peter Griffin wrote:
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 702ca10..269ad3b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1325,6 +1325,7 @@ F:	drivers/pinctrl/pinctrl-st.c
>  F:	drivers/media/rc/st_rc.c
>  F:	drivers/i2c/busses/i2c-st.c
>  F:	drivers/tty/serial/st-asc.c
> +F:	drivers/usb/dwc3/dwc3-st.c
>  
>  ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
