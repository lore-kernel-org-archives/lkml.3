Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbaKSKp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:45:26 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:48847 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaKSKpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:45:21 -0500
Date: Wed, 19 Nov 2014 10:45:15 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com
Subject: Re: [PATCH] MAINTAINERS: Add ahci_st.c to ARCH/STI architecture
Message-ID: <20141119104515.GJ13959@x1>
References: <1416386694-7402-1-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416386694-7402-1-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Peter Griffin wrote:

> This patch adds the ahci_st.c driver found on STMicroelectronics
> stih41x consumer electronics SoC's into the STI arch section
> of the maintainers file.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/MAINTAINERS b/MAINTAINERS
> index a20df9b..2b0a53e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1430,6 +1430,7 @@ F:	drivers/tty/serial/st-asc.c
>  F:	drivers/usb/dwc3/dwc3-st.c
>  F:	drivers/usb/host/ehci-st.c
>  F:	drivers/usb/host/ohci-st.c
> +F:	drivers/ata/ahci_st.c
>  
>  ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
>  M:	Lennert Buytenhek <kernel@wantstofly.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
