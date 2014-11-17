Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaKQVfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:35:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47096 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaKQVfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:35:38 -0500
Date: Mon, 17 Nov 2014 16:35:32 -0500 (EST)
Message-Id: <20141117.163532.788436432373669437.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: fabf@skynet.be, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] net/core: include linux/types.h instead
 of asm/types.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416259376.18588.8.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1416258502-9001-1-git-send-email-fabf@skynet.be>
	<1416259376.18588.8.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Nov 2014 13:35:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 17 Nov 2014 13:22:56 -0800

> On Mon, 2014-11-17 at 22:08 +0100, Fabian Frederick wrote:
>> Signed-off-by: Fabian Frederick <fabf@skynet.be>
>> ---
>>  net/core/link_watch.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/net/core/link_watch.c b/net/core/link_watch.c
>> index bd0767e..49a9e3e 100644
>> --- a/net/core/link_watch.c
>> +++ b/net/core/link_watch.c
>> @@ -21,7 +21,7 @@
>>  #include <linux/spinlock.h>
>>  #include <linux/workqueue.h>
>>  #include <linux/bitops.h>
>> -#include <asm/types.h>
>> +#include <linux/types.h>
>>  
> 
> We have 99 such occurrences in net/
> 
> Are you going to send 99 patches ?

Yeah, probably best to consolidate into one or a few patches.
