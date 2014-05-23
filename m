Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaEWVkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:40:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33351 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaEWVkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:40:14 -0400
Message-ID: <537FBFF3.7040608@ti.com>
Date: Sat, 24 May 2014 00:38:59 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <lee.jones@linaro.org>, <arnd@arndb.de>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <grant.likely@linaro.org>
CC: <rdunlap@infradead.org>, <mturquette@linaro.org>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <olof@lixom.net>, <w-kwok2@ti.com>,
        <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <m-karicheri2@ti.com>,
        <sergei.shtylyov@cogentembedded.com>
Subject: Re: [Patch v7 0/7] Introduce keystone reset driver
References: <1400859812-5761-1-git-send-email-ivan.khoronzhuk@ti.com> <537FBD6A.9040308@ti.com>
In-Reply-To: <537FBD6A.9040308@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/24/2014 12:28 AM, Santosh Shilimkar wrote:
> On Friday 23 May 2014 11:43 AM, Ivan Khoronzhuk wrote:
>> These patches introduce keystone reset driver.
>>
>> The keystone SoC can be rebooted in several ways. By external reset
>> pin, by soft and by watchdogs. This driver allows software reset and reset
>> by one of the watchdogs. Also added opportunity to set soft/hard reset type.
>>
>> Based on linux-next/master
>>
>> v7..v6
>>    power: reset: keystone-reset: introduce keystone reset driver
>>    power: reset: add bindings for keystone reset driver
>>    ARM: dts: keystone: update reset node to work with reset driver
>> 	- s/wdt_list/wdt-list/g
>>
> I dropped patch 3/7 since its already queued up in mfd tree. Rest
> of the patches with minor commit edits queued for 3.16. Pull request
> to follow.
>
> Regards,
> Santosh

Thanks.

-- 
Regards,
Ivan Khoronzhuk

