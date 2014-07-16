Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbaGPNeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:34:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57025 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932902AbaGPNeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:34:24 -0400
Message-ID: <53C67F5A.6070500@ti.com>
Date: Wed, 16 Jul 2014 19:04:18 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, <linux-watchdog@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <wim@iguana.be>
Subject: Re: [RESEND PATCH 1/3] watchdog: dw_wdt: Remove the un-necessary
 check after platform_get_resource()
References: <1405516744-29333-1-git-send-email-george.cherian@ti.com> <53C67D7A.4040705@roeck-us.net>
In-Reply-To: <53C67D7A.4040705@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On 7/16/2014 6:56 PM, Guenter Roeck wrote:
> On 07/16/2014 06:19 AM, George Cherian wrote:
>> devm_ioremap_resource() checks for valid resource.
>> Remove the un-necessary check after platform_get_resource().
>>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>
> All three patches have my Reviewed-by: tag and are in my watchdog-next 
> branch.
> Of course that does not guarantee that Wim will pick them up, but it 
> is quite
> likely.
Thanks for the update.
>
> Guenter
>


-- 
-George

