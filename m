Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab3JQOzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:55:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47727 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3JQOzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:55:02 -0400
Message-ID: <525FFA40.9050901@wwwdotorg.org>
Date: Thu, 17 Oct 2013 08:54:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Christian Daudt <bcm@fixthebug.org>, Sherman Yin <syin@broadcom.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>	<1380846199-12829-4-git-send-email-syin@broadcom.com> <CAEPRUYqfpdp1GqxBgx-q=hyvQDe4uyi6okzHPW2QmfmPG_Z3NQ@mail.gmail.com>
In-Reply-To: <CAEPRUYqfpdp1GqxBgx-q=hyvQDe4uyi6okzHPW2QmfmPG_Z3NQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 12:03 AM, Christian Daudt wrote:
> On Thu, Oct 3, 2013 at 5:23 PM, Sherman Yin <syin@broadcom.com> wrote:
>> Adds pinctrl driver for Broadcom Capri (BCM281xx) SoCs.
>>
>> Signed-off-by: Sherman Yin <syin@broadcom.com>
>> Reviewed-by: Christian Daudt <bcm@fixthebug.org>
>> Reviewed-by: Matt Porter <matt.porter@linaro.org>
>> ---
>>  arch/arm/mach-bcm/Kconfig       |    2 +
>>  drivers/pinctrl/Kconfig         |   10 +
>>  drivers/pinctrl/Makefile        |    1 +
>>  drivers/pinctrl/pinctrl-capri.c | 1727 +++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 1740 insertions(+)
>>  create mode 100644 drivers/pinctrl/pinctrl-capri.c
>>
>> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
>> index 69d67f7..2546365 100644
>> --- a/arch/arm/mach-bcm/Kconfig
>> +++ b/arch/arm/mach-bcm/Kconfig
>> @@ -10,6 +10,8 @@ config ARCH_BCM
>>         select GENERIC_CLOCKEVENTS
>>         select GENERIC_TIME
>>         select GPIO_BCM
>> +       select PINCTRL
>> +       select PINCTRL_CAPRI
>>         select SPARSE_IRQ
>>         select TICK_ONESHOT
>>         select CACHE_L2X0
> 
> On your subsequent patchset pls move this from Kconfig to
> arm/configs/bcm_defconfig, and break that modification into a separate
> patch from the drivers/* modification.

The other SoCs I'm familiar with all select this from their ARCH_xxx
config symbol.

