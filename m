Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934193AbaEFHSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:18:51 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:65238 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933838AbaEFHSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:18:49 -0400
Date: Tue, 6 May 2014 08:18:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Pankaj Dev <pankaj.dev@st.com>
Subject: Re: [PATCH 1/9] ARM: STi: DT: STiH416: 416 DT Entry for clockgen
 A0/1/10/11/12
Message-ID: <20140506071843.GD5206@lee--X1>
References: <1399305223-18703-1-git-send-email-gabriel.fernandez@linaro.org>
 <1399305223-18703-2-git-send-email-gabriel.fernandez@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399305223-18703-2-git-send-email-gabriel.fernandez@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Patch adds DT entries for clockgen A0/1/10/11/12
> 
> Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> ---
>  arch/arm/boot/dts/stih416-clks.h     |  15 ++

This should live in include/dt-bindings/clk

>  arch/arm/boot/dts/stih416-clock.dtsi | 477 ++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/stih416.dtsi       |  10 +-
>  3 files changed, 497 insertions(+), 5 deletions(-)
>  create mode 100644 arch/arm/boot/dts/stih416-clks.h

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
