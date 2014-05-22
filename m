Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaEVL6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:58:22 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:37344 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbaEVL6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:58:21 -0400
Date: Thu, 22 May 2014 12:58:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        Christophe Kerello <christophe.kerello@st.com>
Subject: Re: [PATCH v2 09/10] mtd: st_spi_fsm: Provide mask to obtain correct
 boot device pins
Message-ID: <20140522115816.GX6679@lee--X1>
References: <1400757848-18075-1-git-send-email-lee.jones@linaro.org>
 <1400757848-18075-10-git-send-email-lee.jones@linaro.org>
 <20140522115643.GW6679@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140522115643.GW6679@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, wrong patch, please ignore this v2.

> mtd: st_spi_fsm: Provide documentation for boot device mask property
> 
> The system configuration registers which display which device the system
> booted on are in the same place on all boards which support the FSM.
> However, the bits do shift every so slightly.  To combat these we're
> adding a new property which supplies the necessary mask used to abstract
> the required information.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> diff --git a/Documentation/devicetree/bindings/mtd/st-fsm.txt b/Documentation/devicetree/bindings/mtd/st-fsm.txt
> index c248939..2ef9710 100644
> --- a/Documentation/devicetree/bindings/mtd/st-fsm.txt
> +++ b/Documentation/devicetree/bindings/mtd/st-fsm.txt
> @@ -11,6 +11,10 @@ Optional properties:
>    - st,syscfg          : Phandle to boot-device system configuration registers
>    - st,boot-device-reg : Address of the aforementioned boot-device register(s)
>    - st,boot-device-spi : Expected boot-device value if booted via this device
> +  - st,boot-device-msk : Mask to use when extracting boot device from the
> +                        above system config registers
> +  NB: If any of the st,boot-device-* properties are missing, the driver falls
> +  back to the default assumption of 'booted from SPI'.
>  
>  Example:
>         spifsm: spifsm@fe902000{

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
