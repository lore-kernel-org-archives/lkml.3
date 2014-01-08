Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbaAHSil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:38:41 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50646 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaAHSii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:38:38 -0500
MIME-Version: 1.0
In-Reply-To: <20140108144056.GD10725@S2101-09.ap.freescale.net>
References: <1389148163-5243-1-git-send-email-john.tobias.ph@gmail.com>
	<20140108144056.GD10725@S2101-09.ap.freescale.net>
Date: Wed, 8 Jan 2014 10:38:36 -0800
Message-ID: <CACUGKYMU2K2q5nU-PyoVMNk0ivQdsLrsKg=uKQcu5aPfcnp6GA@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: imx: select ARCH_HAS_CPUFREQ for iMX6SL
From: John Tobias <john.tobias.ph@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: "<kernel@pengutronix.de>" <kernel@pengutronix.de>,
        "<linux@arm.linux.org.uk>" <linux@arm.linux.org.uk>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's fine with me. We can save two lines in the file.

> On Jan 8, 2014, at 6:40 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
>
>> On Tue, Jan 07, 2014 at 06:29:23PM -0800, John Tobias wrote:
>> iMX6SL now supports the cpufreq scaling by re-using the imx6q-cpufreq driver.
>> By adding it, the user has the capability to select the said driver without
>> depending it to SOC_IMX6Q.
>>
>> Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
>> ---
>> Changes since v1:
>> - Fix typo in commit log
>> - Added Shawn Guo on Cc
>>
>> arch/arm/mach-imx/Kconfig | 1 +
>> 1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
>> index 7a6e6f7..704e5ae 100644
>> --- a/arch/arm/mach-imx/Kconfig
>> +++ b/arch/arm/mach-imx/Kconfig
>> @@ -808,6 +808,7 @@ config SOC_IMX6Q
>>
>> config SOC_IMX6SL
>>    bool "i.MX6 SoloLite support"
>> +    select ARCH_HAS_CPUFREQ
>
> Since we will eventually enable CPUFREQ and OPP for most of the
> platforms, maybe we should just move selection of ARCH_HAS_CPUFREQ,
> ARCH_HAS_OPP and PM_OPP into 'config ARCH_MXC'?
>
> Shawn
>
>>    select ARM_ERRATA_754322
>>    select ARM_ERRATA_775420
>>    select ARM_GIC
>> --
>> 1.8.3.2
>
