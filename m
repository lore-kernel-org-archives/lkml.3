Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab3K2Plx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:41:53 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41527 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab3K2Plw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:41:52 -0500
Message-ID: <5298B440.1020905@ti.com>
Date: Fri, 29 Nov 2013 17:35:28 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
CC: Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] memory: ti-aemif: introduce AEMIF driver
References: <1384962416-14862-1-git-send-email-ivan.khoronzhuk@ti.com> <1384962416-14862-2-git-send-email-ivan.khoronzhuk@ti.com> <5298B370.3090405@ti.com>
In-Reply-To: <5298B370.3090405@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2013 05:32 PM, Santosh Shilimkar wrote:
> On Wednesday 20 November 2013 10:46 AM, Ivan Khoronzhuk wrote:
>> Add new AEMIF driver for EMIF16 Texas Instruments controller.
>> The EMIF16 module is intended to provide a glue-less interface to
>> a variety of asynchronous memory devices like ASRA M, NOR and NAND
>> memory. A total of 256M bytes of any of these memories can be
>> accessed at any given time via four chip selects with 64M byte access

[...]

>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id aemif_of_match[] = {
>> +	{ .compatible = "ti,davinci-aemif", },
>> +	{ .compatible = "ti,keystone-aemif", },
>> +	{ .compatible = "ti,omap-L138-aemif", },
>> +	{},
>> +};
>> +
> Looks like you are yet to update the patches from
> previous comments. Did I miss v2 or you haven't posted
> that yet ?

No. This is v2, actually :( (the mess was already noticed) it was posted 
after v1 (https://lkml.org/lkml/2013/11/11/352), but people continue 
commenting v1, for some reasons.

Next version will be posted when bindings will be clarified finally.

Regards,
-grygorii


