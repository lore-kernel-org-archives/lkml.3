Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab3KROcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:32:06 -0500
Received: from mail.active-venture.com ([67.228.131.205]:52718 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab3KROcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:32:00 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <528A24DE.1010507@roeck-us.net>
Date: Mon, 18 Nov 2013 06:31:58 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, wim@iguana.be,
        nsekhar@ti.com, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org
CC: grant.likely@linaro.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, galak@kernel.crashing.org,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Fwd: [PATCH 1/8] watchdog: davinci: change driver to use WDT
 core
References: <1383680783-12114-2-git-send-email-ivan.khoronzhuk@ti.com> <527A287C.2090401@ti.com> <5287D5A7.7060702@roeck-us.net> <5289FE60.2040207@ti.com>
In-Reply-To: <5289FE60.2040207@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 03:47 AM, ivan.khoronzhuk wrote:

>>>    MODULE_LICENSE("GPL");
>>> -MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
>>>    MODULE_ALIAS("platform:watchdog");
>>>
>> You might want to rename the platform driver to something like
>> davinci-wdt and change the MODULE_ALIAS
>> accordingly.
>>
>
> Yes, it could be changed but not in this patch.
>
Seems to me this would be the perfect time to change it, as you switch to use
the watchdog core which permits more than one active watchdog in the system.

Guenter

