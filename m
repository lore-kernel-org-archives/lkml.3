Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaESJNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:13:55 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:63031 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbaESJNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:13:53 -0400
Message-ID: <5379CB5C.1070202@linaro.org>
Date: Mon, 19 May 2014 11:14:04 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>, tglx@linutronix.de,
        shawn.guo@linaro.org
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv3 0/3] clocksource: Add Freescale FlexTimer Module (FTM)
 timer support
References: <1398737939-5334-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1398737939-5334-1-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 04:18 AM, Xiubo Li wrote:
>
> Changes in V3:
> - Fix the ftm_irq_disable.
>
> Changes in V2:
> - Add big-endian support.
> - Add using pr_err instead of BUG_ON.
> - Add more detail comment message of FTM.
> - Add DT binding documentation.
> - Remove some header files and macros not useful.
>
>
> Xiubo Li (3):
>    clocksource: ftm: Add FlexTimer Module (FTM) Timer devicetree
>      Documentation
>    ARM: dts: vf610: Add Freescale FlexTimer Module timer node.
>    clocksource: Add Freescale FlexTimer Module (FTM) timer support
>
>   .../devicetree/bindings/timer/fsl,ftm-timer.txt    |  31 ++
>   arch/arm/boot/dts/vf610.dtsi                       |  12 +
>   drivers/clocksource/Kconfig                        |   5 +
>   drivers/clocksource/Makefile                       |   1 +
>   drivers/clocksource/fsl_ftm_timer.c                | 344 +++++++++++++++++++++
>   5 files changed, 393 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/timer/fsl,ftm-timer.txt
>   create mode 100644 drivers/clocksource/fsl_ftm_timer.c

By the way, when reposting the serie, could you please add Rob Herring 
and Grant likely as Cc to review the dts part ?

Thanks
   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

