Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934076Ab3FSBTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:19:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38967 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933979Ab3FSBTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:19:48 -0400
Message-ID: <51C10732.5040107@codeaurora.org>
Date: Tue, 18 Jun 2013 18:19:46 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rohit Vaswani <rvaswani@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 0/4] ARM: MSM: Consolidate GPIOMUX for 7x30 and 8x50
References: <1371603747-27436-1-git-send-email-rvaswani@codeaurora.org>
In-Reply-To: <1371603747-27436-1-git-send-email-rvaswani@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

**Please ignore this 4 patch series**
Sorry for the inconvenience.

On 6/18/2013 6:02 PM, Rohit Vaswani wrote:
> The previous gpio clean up series left some room for consolidation
> and required a few fixes.
>
> Rohit Vaswani (4):
>    ARM: msm: dts: Fix the gpio register address for msm8960
>    drivers: gpio: msm: Fix the error condition for reading ngpio
>    ARM: msm: Consolidate gpiomux for older architectures
>    drivers: gpio: msm: Remove __devinit
>
>   arch/arm/boot/dts/msm8960-cdp.dts |    4 ++--
>   arch/arm/mach-msm/Kconfig         |    3 +--
>   arch/arm/mach-msm/gpiomux-v1.c    |   33 ---------------------------------
>   arch/arm/mach-msm/gpiomux.h       |   10 ----------
>   drivers/gpio/gpio-msm-v1.c        |    2 +-
>   drivers/gpio/gpio-msm-v2.c        |    2 +-
>   6 files changed, 5 insertions(+), 49 deletions(-)
>   delete mode 100644 arch/arm/mach-msm/gpiomux-v1.c
>


Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

