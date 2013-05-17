Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3EQKtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 06:49:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54572 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750Ab3EQKtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 06:49:06 -0400
Message-ID: <51960A96.3050000@ti.com>
Date: Fri, 17 May 2013 13:46:46 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mfd: twl-core: convert to module_i2c_driver()
References: <1366723151-23209-1-git-send-email-grygorii.strashko@ti.com> <1366723151-23209-3-git-send-email-grygorii.strashko@ti.com> <20130516221710.GU22822@zurbaran> <20130516225810.GQ5600@atomide.com>
In-Reply-To: <20130516225810.GQ5600@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.172]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 01:58 AM, Tony Lindgren wrote:
> * Samuel Ortiz <sameo@linux.intel.com> [130516 15:22]:
>> Hi Grygorii,
>>
>> On Tue, Apr 23, 2013 at 04:19:10PM +0300, Grygorii Strashko wrote:
>>> Shift TWL initialization to module/device init layer, because I2C now is
>>> not initialized on subsys init layer and shifted to module/device init
>>> layer instead.
>>>
>>> The I2C <--> TWL dependency should be resolved in drivers/Makefile now.
>>>
>>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>> Cc: linux-omap@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>>
>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>> ---
>>>   drivers/mfd/twl-core.c |   12 +-----------
>>>   1 file changed, 1 insertion(+), 11 deletions(-)
>> I applied this one to mfd-next for now, and will move it to mfd-fixes if
>> someone confirms that this is indeed a fix.
> Thanks, AFAIK it can wait until v3.11 merge window.
>
> Regards,
>
> Tony
Thanks, it's optimization which reduces the number of deferred probes at 
boot

Regards,
-grygorii


