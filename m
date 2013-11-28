Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab3K1GGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 01:06:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57362 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab3K1GGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 01:06:05 -0500
Message-ID: <5296DCD6.3030002@ti.com>
Date: Thu, 28 Nov 2013 11:34:06 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mark.rutland@arm.com>,
        <wim@iguana.be>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <Pawel.Moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <grygorii.strashko@ti.com>
Subject: Re: [PATCH] watchdog: davinci: rename platform driver to davinci-wdt
References: <1385559113-4354-1-git-send-email-ivan.khoronzhuk@ti.com> <5295FB0E.4070406@ti.com> <52961665.3060309@roeck-us.net>
In-Reply-To: <52961665.3060309@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 November 2013 09:27 PM, Guenter Roeck wrote:
> On 11/27/2013 06:00 AM, Sekhar Nori wrote:
>> On Wednesday 27 November 2013 07:01 PM, Ivan Khoronzhuk wrote:
>>> As we switch to use the watchdog core which permits more than one
>>> active watchdog in the system, rename platform driver to
>>> "davinci-wdt" to be identifiable.
>>>
>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>>
>> Looks good to me. Since bulk of this patch touches mach-davinci, I would
>> like to take this through my tree to avoid conflicts with other
>> mach-davinci patches I accept.
>>
> 
> Good idea, and makes sense.

Added to v3.14/soc with your Reviewed-by

Thanks,
Sekhar

[1]
https://git.kernel.org/cgit/linux/kernel/git/nsekhar/linux-davinci.git/log/?h=v3.14/soc
