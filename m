Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaF1KzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 06:55:11 -0400
Received: from 78-32-181-23.static.enta.net ([78.32.181.23]:59267 "EHLO
	mail.linicks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaF1KzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 06:55:09 -0400
Message-ID: <53AE9F0B.1080207@linicks.net>
Date: Sat, 28 Jun 2014 11:55:07 +0100
From: Nick Warne <nick@linicks.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.15.2 build error on AMD64
References: <53AE9058.50902@linicks.net> <20140628101240.GA6357@pd.tnic> <53AE9863.6050102@linicks.net>
In-Reply-To: <53AE9863.6050102@linicks.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/14 11:26, Nick Warne wrote:
>
> On 28/06/14 11:12, Borislav Petkov wrote:
>> On Sat, Jun 28, 2014 at 10:52:24AM +0100, Nick Warne wrote:
>>> Hi Everybody,
>>>
>>> Today I was trying to build 3.15.2 on AMD64 from kernel 3.14.8 and get this:
>>>
>>>   CC      fs/mbcache.o
>>> fs/mbcache.c: In function ‘__spin_lock_mb_cache_entry’:
>>> fs/mbcache.c:134: error: SSE register return with SSE disabled
>>> make[1]: *** [fs/mbcache.o] Error 1
>>
>> I can't trigger that here.
>>
>> Please send your .config. Also, before building, did you clean up your
>> source tree properly by saving the .config somewhere else and doing
>> "make mrproper"?
>
> Thanks for prompt reply.
>
> I always do a mrproper followed by grabbing current .config from /proc
> and issuing make oldconfig.
>
> Attached is my config file.
>
> Also, for what it is worth:
>
> gcc version 4.8.2 (GCC)

Whoops - that is WRONG (too many ssh terminals)

gcc version 4.2.4

Nick
-- 
"A bug in the code is worth two in the documentation."
FSF Associate Member 5508
http://linicks.net/
http://pi.linicks.net/
