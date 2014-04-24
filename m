Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaDXJyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:54:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45258 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbaDXJx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:53:59 -0400
Message-ID: <5358DF50.9010106@linaro.org>
Date: Thu, 24 Apr 2014 11:54:24 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Leela Krishna Amudala <leela.krishna@linaro.org>, linux-pm@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: nicolas.pitre@linaro.org, kgene.kim@samsung.com, amit.kucheria@linaro.org,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>
Subject: Re: [PATCH 0/2] Add generic cpu power control functions for exynos
References: <1398331919-28321-1-git-send-email-leela.krishna@linaro.org>
In-Reply-To: <1398331919-28321-1-git-send-email-leela.krishna@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Abhilash and Leela,

FYI I think you are working on similar patches.

On 04/24/2014 11:31 AM, Leela Krishna Amudala wrote:
 > This patchset adds the generic cpu power control functions for
> exynos based SoCs to power up/down and to know the status of the cpu.
>
> Note: This series has been rebased on 3.15-rc1 and tested on
> Exynos based Origen(Cortex-A9) and Arndale-octa(Cortex A7,A15) boards.
>
> Leela Krishna Amudala (2):
>    ARM: EXYNOS: Add generic cpu power control functions for all exynos
>      based SoCs
>    ARM: EXYNOS: use generic exynos cpu power control functions
>
>   arch/arm/mach-exynos/common.h   |    3 +++
>   arch/arm/mach-exynos/platsmp.c  |    9 +++------
>   arch/arm/mach-exynos/pm.c       |   36 ++++++++++++++++++++++++++++++++++++
>   arch/arm/mach-exynos/regs-pmu.h |    6 ++++++
>   4 files changed, 48 insertions(+), 6 deletions(-)
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

