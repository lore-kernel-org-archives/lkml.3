Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbaBDXvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:51:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36835 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157AbaBDXvK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:51:10 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH v2 2/5] clocksource: qcom: Move clocksource code out of mach-msm
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20140204230956.GE20528@codeaurora.org>
Date: Tue, 4 Feb 2014 17:51:06 -0600
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <EE8EC898-CFE4-4953-968A-ECCEEB09DE76@codeaurora.org>
References: <1391553532-27001-1-git-send-email-galak@codeaurora.org> <1391553532-27001-3-git-send-email-galak@codeaurora.org> <20140204230956.GE20528@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 4, 2014, at 5:09 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> On 02/04, Kumar Gala wrote:
>> We intent to share the clocksource code for MSM platforms between legacy
> 
> s/intent/intend/
> 
>> and multiplatform supported qcom SoCs.
>> 
>> Acked-by: Olof Johansson <olof@lixom.net>
>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> 
>> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
>> index cd6950f..81caa16 100644
>> --- a/drivers/clocksource/Kconfig
>> +++ b/drivers/clocksource/Kconfig
>> @@ -140,3 +140,7 @@ config VF_PIT_TIMER
>> 	bool
>> 	help
>> 	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
>> +
>> +config CLKSRC_QCOM
>> +	bool
>> +	depends on ARCH_MSM
> 
> It would be a a little less noisy if  you left this as MSM_TIMER
> (msm is all over the code in that file anyway). Also, why do we
> care about depending on ARCH_MSM here? This is a hidden Kconfig
> option anyway.

I will drop the depends, but not sure what point in leaving this as MSM_TIMER.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

