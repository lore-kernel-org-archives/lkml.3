Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaGVLv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:51:58 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:43996 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaGVLv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:51:56 -0400
Message-ID: <53CE5059.4010107@mm-sol.com>
Date: Tue, 22 Jul 2014 14:51:53 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH v2 1/4] mfd: pm8xxx-spmi: add support for Qualcomm SPMI
 PMICs
References: <1405613855-27572-1-git-send-email-svarbanov@mm-sol.com> <1405613855-27572-2-git-send-email-svarbanov@mm-sol.com> <20140722110341.GE8406@lee--X1>
In-Reply-To: <20140722110341.GE8406@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 02:03 PM, Lee Jones wrote:
> On Thu, 17 Jul 2014, Stanimir Varbanov wrote:
> 
>> From: Josh Cartwright <joshc@codeaurora.org>
>>
>> The Qualcomm SPMI PMIC chips are components used with the
>> Snapdragon 800 series SoC family.  This driver exists
>> largely as a glue mfd component, it exists to be an owner
>> of an SPMI regmap for children devices described in
>> device tree.
>>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> 
> Needs to be signed off by the author.
> 
>> ---
>>  drivers/mfd/Kconfig       |   16 +++++++++++
>>  drivers/mfd/Makefile      |    1 +
>>  drivers/mfd/pm8xxx-spmi.c |   63 +++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 80 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/mfd/pm8xxx-spmi.c
> 
> [...]
> 
>> +++ b/drivers/mfd/pm8xxx-spmi.c
>> @@ -0,0 +1,63 @@
>> +/*
>> + * Copyright (c) 2014, The Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
> 
> There should be a '\n' here.

OK.

> 
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/spmi.h>
>> +#include <linux/regmap.h>
>> +#include <linux/of_platform.h>
> 
> [...]
> 
>> +MODULE_DESCRIPTION("PM8XXX SPMI PMIC driver");
>> +MODULE_ALIAS("platform:" KBUILD_MODNAME);

I will change this to:

MODULE_ALIAS("spmi:pm8xxx-spmi");

>> +MODULE_AUTHOR("The Linux Foundation");
> 
> The Linux Foundation did not write this patch.

OK, I will change the author or remove the tag completely.

> 
>> +MODULE_LICENSE("GPL v2");
> 
> Appart from that:
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
> 

Thanks. I will resend the whole patch set with your acks.

-- 
regards,
Stan
