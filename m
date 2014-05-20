Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaETMU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:20:57 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59787 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaETMUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:20:55 -0400
Date: Tue, 20 May 2014 13:20:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Olof Johansson <olof@lixom.net>, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Subject: Re: [PATCH v6 4/4] ARM: dts: STiH407: Add B2120 board support
Message-ID: <20140520122048.GO24991@lee--X1>
References: <1400579192-17620-1-git-send-email-maxime.coquelin@st.com>
 <1400579192-17620-5-git-send-email-maxime.coquelin@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400579192-17620-5-git-send-email-maxime.coquelin@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014, Maxime COQUELIN wrote:

> B2120 HDK is the reference board for STiH407 SoC.
> It has the following characteristics:
>  - 1GB DDR3
>  - 8GB eMMC / SD-Card slot
>  - 32MB NOR Flash
>  - 1 x Gbit Ethernet
>  - 1 x USB 3.0 port
>  - 1 x Mini-PCIe
>  - 1 x SATA
>  - 1 x HDMI output
>  - 1 x HDMI input
>  - 1 x SPDIF
> 
> This patch only introduces basic functionnalities, such as I2C and UART.
> 
> Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Patrice Chotard <patrice.chotard@st.com>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> ---
>  arch/arm/boot/dts/Makefile          |  3 +-
>  arch/arm/boot/dts/stih407-b2120.dts | 78 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 80 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/stih407-b2120.dts

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
