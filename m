Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaGKIVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:21:10 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46221 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaGKIVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:21:06 -0400
Date: Fri, 11 Jul 2014 09:21:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        gregkh@linuxfoundation.org, srinivas.kandagatla@gmail.com,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] MAINTAINERS: Add st-hcd to ARCH/STI architecture
Message-ID: <20140711082100.GI11948@lee--X1>
References: <1405005486-26355-1-git-send-email-peter.griffin@linaro.org>
 <1405005486-26355-4-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405005486-26355-4-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014, Peter Griffin wrote:

> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 702ca10..359a64e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1325,6 +1325,7 @@ F:	drivers/pinctrl/pinctrl-st.c
>  F:	drivers/media/rc/st_rc.c
>  F:	drivers/i2c/busses/i2c-st.c
>  F:	drivers/tty/serial/st-asc.c
> +F:	drivers/usb/host/st-hcd.c
>  
>  ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
