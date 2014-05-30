Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbaE3Lwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:52:45 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:45108 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaE3Lwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:52:42 -0400
Message-ID: <538870F8.9090507@gmail.com>
Date: Fri, 30 May 2014 13:52:24 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com
CC: t.figa@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, ben-linux@fluff.org,
        linux@arm.linux.org.uk, l.krishna@samsung.com,
        chanho61.park@samsung.com, kyungmin.park@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Add pmu sysreg node to Exynos3250
References: <1401085776-14212-1-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1401085776-14212-1-git-send-email-cw00.choi@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.05.2014 08:29, Chanwoo Choi wrote:
> This patch add pmusysreg node for Exynos3250 to access PMU (Power Management Unit)
> register in a centralized way using syscon driver.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/devicetree/bindings/arm/samsung/pmu.txt | 1 +
>  arch/arm/boot/dts/exynos3250.dtsi                     | 5 +++++
>  2 files changed, 6 insertions(+)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
