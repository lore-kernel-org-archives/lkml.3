Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaFCSLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:11:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56820 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaFCSLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:11:16 -0400
Message-ID: <538E0FC3.8050904@codeaurora.org>
Date: Tue, 03 Jun 2014 11:11:15 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sachin Kamat <spk.linux@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: Re: [PATCH] ARM: Remove ARCH_HAS_CPUFREQ config option
References: <1401746847-3193-1-git-send-email-sboyd@codeaurora.org> <CAK5sBcEbLetRcgPuDJ30RqYjLOHhCXChtKE5ep22ZvEPWc9XwA@mail.gmail.com>
In-Reply-To: <CAK5sBcEbLetRcgPuDJ30RqYjLOHhCXChtKE5ep22ZvEPWc9XwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/14 23:13, Sachin Kamat wrote:
> On Tue, Jun 3, 2014 at 3:37 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> @@ -831,7 +817,6 @@ config ARCH_S5PV210
>>
>>  config ARCH_EXYNOS
>>         bool "Samsung EXYNOS"
>> -       select ARCH_HAS_CPUFREQ
>>         select ARCH_HAS_HOLES_MEMORYMODEL
>>         select ARCH_REQUIRE_GPIOLIB
>>         select ARCH_SPARSEMEM_ENABLE
> I think this patch is not based on the latest code base as ARCH_EXYNOS
> symbol is now defined in arch/arm/mach-exynos/Kconfig file.

Hm.. yes. It was based on linux-next from the middle of May. I'll
regenerate it now.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

