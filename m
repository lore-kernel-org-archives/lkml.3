Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3KYP6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:58:43 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:34594 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab3KYP6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:58:40 -0500
Message-ID: <5293736A.2060108@ti.com>
Date: Mon, 25 Nov 2013 17:57:30 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <grygorii.strashko@ti.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 1/3] mtd: nand: davinci: reuse driver for Keystone arch
References: <1384964699-15134-1-git-send-email-ivan.khoronzhuk@ti.com> <1384964699-15134-2-git-send-email-ivan.khoronzhuk@ti.com> <201311231915.29643.arnd@arndb.de>
In-Reply-To: <201311231915.29643.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2013 08:15 PM, Arnd Bergmann wrote:
> On Wednesday 20 November 2013, Ivan Khoronzhuk wrote:
>> --- a/drivers/mtd/nand/davinci_nand.c
>> +++ b/drivers/mtd/nand/davinci_nand.c
>> @@ -523,6 +523,7 @@ static struct nand_ecclayout hwecc4_2048 __initconst = {
>>   #if defined(CONFIG_OF)
>>   static const struct of_device_id davinci_nand_of_match[] = {
>>          {.compatible = "ti,davinci-nand", },
>> +       {.compatible = "ti,keystone-nand", },
>>          {},
>>   };
>>   MODULE_DEVICE_TABLE(of, davinci_nand_of_match);
>
> Same comment as for the watchdog driver: when the devices are actually compatible,
> the driver does not need to know the new string, the preferred method is to
> set both strings from the .dts file.
>
> 	Arnd
>

Thanks. I'll correct it.

-- 
Regards,
Ivan Khoronzhuk
