Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaEVMMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:12:13 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45776 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaEVMML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:12:11 -0400
Message-ID: <537DE9A7.7090606@linaro.org>
Date: Thu, 22 May 2014 14:12:23 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>, tglx@linutronix.de,
        shawn.guo@linaro.org
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv4 0/3] clocksource: Add Freescale FlexTimer Module (FTM)
 timer support
References: <1400492168-12813-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1400492168-12813-1-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 11:36 AM, Xiubo Li wrote:
> Changes in V4:
> - Add struct ftm_clock_device {} support.
> - peroidic_cyc --> periodic_cyc.
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

DTS binding guys,

any comment on the patches ?

Thanks
   -- Daniel




-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

