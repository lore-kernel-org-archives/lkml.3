Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaDZAkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 20:40:45 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:34598 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaDZAkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 20:40:43 -0400
Message-ID: <535B0087.3000908@gmail.com>
Date: Sat, 26 Apr 2014 02:40:39 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        t.figa@samsung.com
CC: sajjan.linux@gmail.com, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        arnd@arndb.de, marc.zyngier@arm.com, hyunhee.kim@samsung.com,
        sw0312.kim@samsung.com, linux-kernel@vger.kernel.org,
        yj44.cho@samsung.com, inki.dae@samsung.com, kyungmin.park@samsung.com,
        thomas.abraham@linaro.org, ben-linux@fluff.org, olof@lixom.net,
        chanho61.park@samsung.com, sachin.kamat@linaro.org,
        linux-arm-kernel@lists.infradead.org, tushar.behera@linaro.org
Subject: Re: [PATCHv4 1/7] ARM: EXYNOS: Add Exynos3250 SoC ID
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com> <1398388572-30239-2-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1398388572-30239-2-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 25.04.2014 03:16, Chanwoo Choi wrote:
> This patch add Exynos3250's SoC ID. Exynos 3250 is System-On-Chip(SoC) that
> is based on the 32-bit RISC processor for Smartphone. Exynos3250 uses Cortex-A7
> dual cores and has a target speed of 1.0GHz.
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>   arch/arm/mach-exynos/Kconfig             | 22 ++++++++++++++++++++++
>   arch/arm/mach-exynos/exynos.c            |  2 ++
>   arch/arm/plat-samsung/include/plat/cpu.h | 10 ++++++++++
>   3 files changed, 34 insertions(+)

You can add my

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
