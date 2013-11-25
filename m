Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab3KYBsa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 20:48:30 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:52934 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3KYBs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 20:48:28 -0500
Message-ID: <5292ACE6.2020101@gmail.com>
Date: Mon, 25 Nov 2013 09:50:30 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: rkuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: hexagon: kernel: add export symbol function __delay()
References: <528AD6B3.1060507@gmail.com> <20131125011908.GA18921@codeaurora.org>
In-Reply-To: <20131125011908.GA18921@codeaurora.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 09:19 AM, rkuo wrote:
> On Tue, Nov 19, 2013 at 11:10:43AM +0800, Chen Gang wrote:
>> Need add __delay() implementation, or can not pass allmodconfig in
>> next-20131118 tree.
>>
>> The related error:
>>
>>     CC      kernel/locking/spinlock_debug.o
>>   kernel/locking/spinlock_debug.c: In function '__spin_lock_debug':
>>   kernel/locking/spinlock_debug.c:114:3: error: implicit declaration of function '__delay' [-Werror=implicit-function-declaration]
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  arch/hexagon/include/asm/delay.h |    1 +
>>  arch/hexagon/kernel/time.c       |    9 +++++++++
>>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> Thanks again for all the cleanups.  I've tested this and the rest of your
> patches on my internal tree and everything checks out.
> 

OK, thanks. I will/should continue. :-)

> Also just to let you know, I'm still waiting to hear back on that compiler
> bug.
> 

If necessary/suitable, can let me join to the related communication.

> 
> 
> Acked-by: Richard Kuo <rkuo@codeaurora.org>
> 

Thanks.
-- 
Chen Gang
