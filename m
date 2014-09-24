Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaIXN0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:26:09 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:47949 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaIXN0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:26:06 -0400
Message-ID: <5422C612.70906@roeck-us.net>
Date: Wed, 24 Sep 2014 06:24:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, Andreas Werner <andreas.werner@men.de>
CC: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        lm-sensors@lm-sensors.org, wim@iguana.be,
        linux-watchdog@vger.kernel.org, cooloney@gmail.com, rpurdie@rpsys.net,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH v6 2/4] drivers/watchdog/menf21bmc_wdt: introduce MEN
 14F021P00 BMC Watchdog driver
References: <cover.1409161615.git.andreas.werner@men.de> <f21b275c79866e0aa9bbc59e195ae5424e538300.1409161615.git.andreas.werner@men.de> <20140924123548.GE32069@lee--X1>
In-Reply-To: <20140924123548.GE32069@lee--X1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.5422C66D.01E9,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 9
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 05:35 AM, Lee Jones wrote:
> On Wed, 27 Aug 2014, Andreas Werner wrote:
>
>> Added driver to support the 14F021P00 BMC Watchdog.
>> The BMC is a Board Management Controller including watchdog functionality.
>>
>> Signed-off-by: Andreas Werner <andreas.werner@men.de>
>> ---
>>   drivers/watchdog/Kconfig         |  10 ++
>>   drivers/watchdog/Makefile        |   1 +
>>   drivers/watchdog/menf21bmc_wdt.c | 203 +++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 214 insertions(+)
>>   create mode 100644 drivers/watchdog/menf21bmc_wdt.c
>
> I see no reason to keep this dragging on.  I'm going to apply this
> along with the remainder of the set and send a pull-request to all the
> other Maintainers.  This branch is currently under test.
>
> Any fix-ups for review comments can go in subsequently.
>
Tend to agree. I thought I sent it before, but in case I didn't

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

[ for the watchdog driver ]

Guenter

