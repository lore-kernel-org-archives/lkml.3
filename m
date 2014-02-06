Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaBFRKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 12:10:35 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53462 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbaBFRKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 12:10:33 -0500
Message-ID: <52F3C1C6.5030301@ti.com>
Date: Thu, 6 Feb 2014 22:39:26 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Keerthy <j-keerthy@ti.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <sameo@linux.intel.com>, <grant.likely@linaro.org>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] MFD: TPS65218: Add driver for the TPS65218 PMIC
References: <1391665814-18814-1-git-send-email-j-keerthy@ti.com> <1391665814-18814-3-git-send-email-j-keerthy@ti.com> <20140206143700.GA14727@lee--X1>
In-Reply-To: <20140206143700.GA14727@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 February 2014 08:07 PM, Lee Jones wrote:
>> The TPS65218 chip is a power management IC for Portable Navigation Systems
>> and Tablet Computing devices. It contains the following components:
>>
>>   - Regulators.
>>   - Over Temperature warning and Shut down.
>>
>> This patch adds support for tps65218 mfd device. At this time only
>> the regulator functionality is made available.
>>
>> Signed-off-by: Keerthy <j-keerthy@ti.com>
>> ---
>>   drivers/mfd/Kconfig          |   15 +++
>>   drivers/mfd/Makefile         |    1 +
>>   drivers/mfd/tps65218.c       |  281 +++++++++++++++++++++++++++++++++++++++++
> How much different is the TPS65218 to all the other TPS drivers?
>
> drivers/mfd/tps6105x.c
> drivers/mfd/tps65010.c
> drivers/mfd/tps6507x.c
> drivers/mfd/tps65090.c
> drivers/mfd/tps65217.c
> drivers/mfd/tps6586x.c
> drivers/mfd/tps65910.c
> drivers/mfd/tps65911-comparator.c
> drivers/mfd/tps65912-core.c
> drivers/mfd/tps65912-i2c.c
> drivers/mfd/tps65912-irq.c
> drivers/mfd/tps65912-spi.c
> drivers/mfd/tps80031.c
>
> Perhaps some consolidating might be in order?

Well the closest one is tps65217.c  but then register space is different
and components are different. So a new driver.

>

