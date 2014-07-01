Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbaGANjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:39:19 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50473 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbaGANjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:39:17 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53B2B9FC.8000600@roeck-us.net>
Date: Tue, 01 Jul 2014 06:39:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/6] arm64: Support restart through restart notifier
 call chain
References: <1404155499-21177-1-git-send-email-linux@roeck-us.net> <1404155499-21177-3-git-send-email-linux@roeck-us.net> <20140701072647.GI28647@lukather>
In-Reply-To: <20140701072647.GI28647@lukather>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 12:26 AM, Maxime Ripard wrote:
> On Mon, Jun 30, 2014 at 12:11:35PM -0700, Guenter Roeck wrote:
>> The kernel core now supports a notifier call chain to restart the system.
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   arch/arm64/kernel/process.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
>> index 43b7c34..9dd2abd 100644
>> --- a/arch/arm64/kernel/process.c
>> +++ b/arch/arm64/kernel/process.c
>> @@ -43,6 +43,7 @@
>>   #include <linux/hw_breakpoint.h>
>>   #include <linux/personality.h>
>>   #include <linux/notifier.h>
>> +#include <linux/watchdog.h>
>
> I don't think you need this include, or shouldn't it be reboot.h
> instead?
>

Yes, that will be removed in the next version of the patch.

Thanks,
Guenter


