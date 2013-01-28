Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab3A1M7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:59:22 -0500
Received: from multi.imgtec.com ([194.200.65.239]:9551 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab3A1M7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:59:20 -0500
Message-ID: <5106761E.5070001@imgtec.com>
Date: Mon, 28 Jan 2013 12:59:10 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v3 21/44] metag: Time keeping
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <1357831872-29451-22-git-send-email-james.hogan@imgtec.com> <201301260003.43854.arnd@arndb.de>
In-Reply-To: <201301260003.43854.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_28_12_59_11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/13 00:03, Arnd Bergmann wrote:
> On Thursday 10 January 2013, James Hogan wrote:
>> Add time keeping code for metag. Meta hardware threads have 2 timers.
>> The background timer (TXTIMER) is used as a free-running time base, and
>> the interrupt timer (TXTIMERI) is used for the timer interrupt. Both
>> counters traditionally count at approximately 1MHz.
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> ---
>>  arch/metag/include/asm/clock.h     |   51 +++++++++++
>>  arch/metag/include/asm/delay.h     |   29 +++++++
>>  arch/metag/include/asm/mach/arch.h |    4 +
>>  arch/metag/kernel/clock.c          |   53 ++++++++++++
>>  arch/metag/kernel/time.c           |  163 ++++++++++++++++++++++++++++++++++++
> 
> We are actually moving clocksource drivers to drivers/clocksource
> now, maybe you can move this one too.

Yes, will do.

Thanks
James

