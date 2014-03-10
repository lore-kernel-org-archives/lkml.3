Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaCJMeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:34:14 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:49946 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaCJMeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:34:11 -0400
Date: Mon, 10 Mar 2014 12:34:05 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Subject: Re: [PATCH v3 1/5] ARM: STi: Add STiH407 SoC support
Message-ID: <20140310123405.GU14976@lee--X1>
References: <1394203251-25361-1-git-send-email-maxime.coquelin@st.com>
 <1394203251-25361-2-git-send-email-maxime.coquelin@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394203251-25361-2-git-send-email-maxime.coquelin@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds support to STiH407 SoC.
> 
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> ---
>  Documentation/arm/sti/stih407-overview.txt    | 18 ++++++++++++++++++
>  Documentation/devicetree/bindings/arm/sti.txt | 15 +++++++++++++++
>  arch/arm/mach-sti/Kconfig                     |  9 +++++++++
>  arch/arm/mach-sti/board-dt.c                  |  1 +
>  4 files changed, 43 insertions(+)
>  create mode 100644 Documentation/arm/sti/stih407-overview.txt
>  create mode 100644 Documentation/devicetree/bindings/arm/sti.txt

<snip>

> +config SOC_STIH407
> +	bool "STiH407 STMicroelectronics Consumer Electronics family"
> +	default y
> +	help
> +	  This enables support for STMicroelectronics Digital Consumer
> +	  Electronics family StiH407 parts, primarily targeted at set-top-box
> +	  and other digital audio/video applications using Flattened Device
> +	  Trees.
> +

Are these configs actually used for something?

<snip>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
