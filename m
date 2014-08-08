Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbaHHLQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:16:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37593 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738AbaHHLQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:16:19 -0400
Message-ID: <53E4B157.6080405@ti.com>
Date: Fri, 8 Aug 2014 16:45:35 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@gmail.com>, <maxime.coquelin@st.com>,
        <patrice.chotard@st.com>
CC: <lee.jones@linaro.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/3] MAINTAINERS: Add phy-stih41x-usb.c to ARCH/STI architecture
References: <1407493175-2611-1-git-send-email-peter.griffin@linaro.org> <1407493175-2611-4-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1407493175-2611-4-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 08 August 2014 03:49 PM, Peter Griffin wrote:
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>

Empty commit message is not recommended even though the patch seems obvious.

Thanks
Kishon

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c2066f4..6283d83 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1356,6 +1356,7 @@ F:	drivers/pinctrl/pinctrl-st.c
>  F:	drivers/media/rc/st_rc.c
>  F:	drivers/i2c/busses/i2c-st.c
>  F:	drivers/tty/serial/st-asc.c
> +F:	drivers/phy/phy-stih41x-usb.c
>  
>  ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
> 
