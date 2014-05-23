Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaEWQjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:39:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53215 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaEWQjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:39:40 -0400
MIME-Version: 1.0
In-Reply-To: <1400857952-6963-5-git-send-email-gdjakov@mm-sol.com>
References: <1400857952-6963-1-git-send-email-gdjakov@mm-sol.com>
	<1400857952-6963-5-git-send-email-gdjakov@mm-sol.com>
Date: Fri, 23 May 2014 18:39:39 +0200
Message-ID: <CABuKBe+B_Ga-w4aA4dApDTa26rCuhetRTJku27Madm+fHtDcLA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ARM: debug: qcom: add UART addresses to Kconfig help
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: Russell King <linux@arm.linux.org.uk>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, sboyd@codeaurora.org,
        rvaswani@codeaurora.org, davidb@codeaurora.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-23 17:12 GMT+02:00 Georgi Djakov <gdjakov@mm-sol.com>:
> Add information about the APQ8084 debug UART physical and virtual
> addresses in the DEBUG_QCOM_UARTDM Kconfig help section.
> Requires: https://lkml.org/lkml/2014/4/14/312
>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---
>  arch/arm/Kconfig.debug |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 40ee328..e71723d 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -376,6 +376,7 @@ choice
>                   their output to the serial port on Qualcomm devices.
>
>                   ARCH      DEBUG_UART_PHYS   DEBUG_UART_BASE
> +                 APQ8084   0xf995e000        0xfa75e000
>                   MSM8X60   0x19c40000        0xf0040000
>                   MSM8960   0x16440000        0xf0040000
>                   MSM8974   0xf991e000        0xfa71e000

You don't have any uart defined in your dts. You should add them
before any adding low level debug support.
Otherwise there might be problems in booting a multi-platform kernel.

Regards,
Matthias

> --
> 1.7.9.5
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
motzblog.wordpress.com
