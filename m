Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab3HOWj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:39:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46844 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3HOWj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:39:57 -0400
Date: Thu, 15 Aug 2013 15:39:56 -0700 (PDT)
Message-Id: <20130815.153956.753981075193965537.davem@davemloft.net>
To: kongjianjun@gmail.com
Cc: mst@redhat.com, linux-kernel@vger.kernel.org, jasowang@redhat.com,
        edumazet@google.com, vyasevic@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] macvtap: fix up direction in comment on offloading
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAFeW=paTeaNsvK7ai-PPs6+MVW3LbaPaW9et_eu3XuGPpMqnuw@mail.gmail.com>
References: <20130815174626.GA10874@redhat.com>
	<CAFeW=paTeaNsvK7ai-PPs6+MVW3LbaPaW9et_eu3XuGPpMqnuw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 15 Aug 2013 15:39:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amos Kong <kongjianjun@gmail.com>
Date: Fri, 16 Aug 2013 04:41:26 +0800

> On Fri, Aug 16, 2013 at 1:46 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
>> It speaks about receiving frames, so while
>> it says GSO, it really means GRO.
>>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> ---
>>  drivers/net/macvtap.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
>> index a98fb0e..a98ed9f 100644
>> --- a/drivers/net/macvtap.c
>> +++ b/drivers/net/macvtap.c
>> @@ -1047,7 +1047,7 @@ static int set_offload(struct macvtap_queue *q, unsigned long arg)
>>          * accept TSO frames and turning it off means that user space
>>          * does not support TSO.
>>          * For macvtap, we have to invert it to mean the same thing.
>> -        * When user space turns off TSO, we turn off GSO/LRO so that
>> +        * When user space turns off TSO, we turn off GRO/LRO so that
> 
> Right fix.
> 
> Reviewed-by: Amos Kong <kongjianjun@gmail.com>

Applied, thanks.
