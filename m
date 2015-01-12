Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbbALIzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:55:37 -0500
Received: from mail.kernel.org ([198.145.29.136]:33824 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbbALIzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:55:35 -0500
Message-ID: <54B38BFF.40601@kernel.org>
Date: Mon, 12 Jan 2015 17:55:27 +0900
From: Kukjin Kim <kgene@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Jaewon Kim <jaewon02.kim@samsung.com>
CC: Kukjin Kim <kgene@kernel.org>, linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 0/4] ARM: dts: Add USB node for exynos3250 SoC
 boards
References: <1420639701-1524-1-git-send-email-jaewon02.kim@samsung.com>
In-Reply-To: <1420639701-1524-1-git-send-email-jaewon02.kim@samsung.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/15 23:08, Jaewon Kim wrote:
> This patch series adds USB device node and phy for exynos3250 SoC.
> And enables for rinato and monk boards.
> 
> Changes in v2:
>  - remove unnessasary property "samsung,sysreg-phandle"
>  - change "xusbxti" clock to "CLK_SCLK_UPLL"
> 
> Jaewon Kim (4):
>   ARM: dts: Add exynos_usbphy node for exynos3250
>   ARM: dts: Add hsotg node for exynos3250
>   ARM: dts: Enable USB node for exynos3250-rinato
>   ARM: dts: Enable USB node for exynos3250-monk
> 
>  arch/arm/boot/dts/exynos3250-monk.dts   |   10 ++++++++++
>  arch/arm/boot/dts/exynos3250-rinato.dts |   10 ++++++++++
>  arch/arm/boot/dts/exynos3250.dtsi       |   21 +++++++++++++++++++++
>  3 files changed, 41 insertions(+)
> 
Applied this series.

Thanks,
Kukjin
